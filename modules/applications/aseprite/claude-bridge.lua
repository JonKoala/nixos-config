-- Claude bridge: runs Lua sent through a private folder on the open sprite.
-- Start from File > Scripts; close the dialog to stop.
--
-- Request (request.lua, must be written atomically):
--   first line "-- id: <unique id>"; optional second line "-- raw" to run
--   without a transaction (needed to open/close sprites).
-- Response (response.txt): id, then "ok" or "error", then the output.
-- preview.png: the active frame, enlarged, after each request.

local runtime = os.getenv("XDG_RUNTIME_DIR")
if not runtime then
  error("XDG_RUNTIME_DIR is not set")
end

local dir = app.fs.joinPath(runtime, "aseprite-claude")
local requestPath = app.fs.joinPath(dir, "request.lua")
local responsePath = app.fs.joinPath(dir, "response.txt")
local previewPath = app.fs.joinPath(dir, "preview.png")
app.fs.makeAllDirectories(dir)

local function readRequest()
  if not app.fs.isFile(requestPath) then return nil end
  local f = assert(io.open(requestPath, "r"))
  local code = f:read("a")
  f:close()
  local id = code:match("^%-%- id: (%S+)")
  if not id then return nil end
  return id, code
end

local function savePreview()
  local sprite = app.sprite
  if not sprite then return end
  local image = Image(sprite.width, sprite.height, ColorMode.RGB)
  image:drawSprite(sprite, app.frame or 1)
  local largest = math.max(sprite.width, sprite.height)
  local scale = math.max(1, math.min(16, 512 // largest))
  image:resize(sprite.width * scale, sprite.height * scale)
  image:saveAs(previewPath)
end

-- Requests only see what is listed here: no io, os, load, app.fs, app.open,
-- timers, sockets or event handlers. This is not a perfect sandbox: methods
-- such as sprite:saveAs still exist on Aseprite's own objects.
local allowedGlobals = {
  "assert", "error", "ipairs", "next", "pairs", "pcall", "select",
  "tonumber", "tostring", "type",
  "Color", "Point", "Rectangle", "Selection", "Size",
  "AniDir", "BlendMode", "ColorMode", "FlipType", "Ink", "Align",
  "Range", "RangeType", "SpriteSheetType",
}

local allowedApp = {
  "apiVersion", "version", "sprite", "sprites", "layer", "cel", "frame",
  "image", "tag", "tool", "brush", "fgColor", "bgColor", "range",
  "pixelColor", "transaction", "undo", "redo", "refresh", "useTool",
}

local allowedCommands = {
  "CanvasSize", "ChangePixelFormat", "CropSprite", "FlattenLayers", "Flip",
  "MergeDownLayer", "Outline", "ReplaceColor", "Rotate", "SpriteSize",
}

local writableApp = {
  sprite = true, layer = true, cel = true, frame = true, tool = true,
  brush = true, fgColor = true, bgColor = true,
}

local function toSet(list)
  local set = {}
  for _, name in ipairs(list) do set[name] = true end
  return set
end

local function copyTable(source)
  local copy = {}
  for key, value in pairs(source) do copy[key] = value end
  return copy
end

-- Wraps a constructor so it can't load files.
local function withoutFiles(constructor)
  return function(...)
    for _, argument in ipairs({ ... }) do
      if type(argument) == "string" then
        error("loading files is not allowed")
      end
      if type(argument) == "table" and
        (argument.fromFile or argument.fromResource or argument.filename) then
        error("loading files is not allowed")
      end
    end
    return constructor(...)
  end
end

local function makeEnvironment(output)
  local appKeys, commandKeys = toSet(allowedApp), toSet(allowedCommands)
  local env = {}
  for _, name in ipairs(allowedGlobals) do env[name] = _G[name] end

  env.string = copyTable(string)
  env.string.dump = nil
  env.table = copyTable(table)
  env.math = copyTable(math)

  env.Sprite = withoutFiles(Sprite)
  env.Image = withoutFiles(Image)
  env.Palette = withoutFiles(Palette)
  env.Brush = withoutFiles(Brush)
  env.ImageSpec = ImageSpec

  local command = setmetatable({}, {
    __metatable = false,
    __newindex = function() error("app.command is read-only") end,
    __index = function(_, key)
      if commandKeys[key] then return app.command[key] end
      error("app.command." .. tostring(key) .. " is not allowed")
    end,
  })

  env.app = setmetatable({}, {
    __metatable = false,
    __newindex = function(_, key, value)
      if not writableApp[key] then
        error("setting app." .. tostring(key) .. " is not allowed")
      end
      app[key] = value
    end,
    __index = function(_, key)
      if key == "command" then return command end
      if appKeys[key] then return app[key] end
      error("app." .. tostring(key) .. " is not allowed")
    end,
  })

  env.print = function(...)
    local parts = table.pack(...)
    for i = 1, parts.n do parts[i] = tostring(parts[i]) end
    output[#output + 1] = table.concat(parts, "\t")
  end
  return env
end

local function execute(id, code)
  local output = {}
  local env = makeEnvironment(output)

  local ok, err
  local chunk, syntaxError = load(code, "=request", "t", env)
  if not chunk then
    ok, err = false, syntaxError
  elseif app.sprite and not code:match("^[^\n]*\n%-%- raw") then
    ok, err = pcall(function() app.transaction("Claude edit", chunk) end)
  else
    ok, err = pcall(chunk)
  end
  if not ok then output[#output + 1] = tostring(err) end

  -- File errors (including denied access) propagate and stop the bridge.
  local f = assert(io.open(responsePath, "w"))
  f:write(id, "\n", ok and "ok" or "error", "\n",
    table.concat(output, "\n"), "\n")
  f:close()
  savePreview()
  return ok
end

-- Headless self-test: process the pending request once.
if not app.isUIAvailable then
  local id, code = readRequest()
  if id then execute(id, code) end
  return
end

-- Ask for file access now, before the timer exists. Denial aborts here.
do
  local f = assert(io.open(responsePath, "w"))
  f:write("ready\n")
  f:close()
end

-- Ignore any request left over from before the bridge was started.
local lastId = readRequest()
local timer
local busy = false
local stopped = false

local function stop()
  stopped = true
  if timer then timer:stop() end
end

local dialog = Dialog { title = "Claude bridge", onclose = stop }
dialog:label { id = "status", text = "Waiting for requests" }
dialog:button { text = "Stop", onclick = function() dialog:close() end }

local function poll()
  local id, code = readRequest()
  if not id or id == lastId then return end
  lastId = id
  local ok = execute(id, code)
  dialog:modify { id = "status", text = (ok and "Done: " or "Failed: ") .. id }
  app.refresh()
end

timer = Timer {
  interval = 0.5,
  ontick = function()
    if busy or stopped then return end
    -- Prompts run a nested event loop: no ticks may run until this finishes,
    -- and any error ends the bridge instead of retrying.
    busy = true
    timer:stop()
    local ok, err = pcall(poll)
    if not ok then
      stop()
      print("Claude bridge stopped: " .. tostring(err))
      return
    end
    busy = false
    if not stopped then timer:start() end
  end,
}

dialog:show { wait = false }
timer:start()
