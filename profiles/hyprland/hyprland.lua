
----------------
--- MONITORS ---
----------------

hl.monitor({ output = "DP-1", mode = "1920x1080@60",  position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-2", mode = "1920x1080@144", position = "1920x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "3840x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", disabled = true })


-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -combi-modi window,drun,ssh -show combi"


------------------
--- WORKSPACES ---
------------------

-- middle monitor (main)
for i = 1, 6 do hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2" }) end
-- left monitor
for i = 7, 8 do hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" }) end
-- right monitor
for i = 9, 10 do hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3" }) end

-- special workspace (scratchpad)
hl.on("workspace.created", function(ws)
    if ws and ws.name == "special:scratchpad_terminal" and ws.is_empty then
        hl.exec_cmd(terminal)
    end
end)


-----------------
--- AUTOSTART ---
-----------------

-- hack for special cases where the window creation process is borked
-- send up to `max` windows of `class` to `ws` at startup; stops at `max` or after `quiet_ms` without a new window
local function startup_workspace(class, ws, max, quiet_ms)
    local rule = hl.window_rule({ name = class .. "-startup", match = { class = class }, workspace = ws .. " silent" })
    local seen = 0
    local sub, quiet

    local function finish()
        rule:set_enabled(false)
        sub:remove()
        if quiet then quiet:set_enabled(false) end
    end

    sub = hl.on("window.open", function(w)
        if not (w and w.class == class) then return end
        seen = seen + 1
        if seen >= max then return finish() end
        if quiet then quiet:set_enabled(false) end
        if quiet_ms then quiet = hl.timer(finish, { timeout = quiet_ms, type = "oneshot" }) end
    end)
end

hl.on("hyprland.start", function()

    -- fix for ghostty's slow startup
    hl.exec_cmd("ghostty --initial-window=false")

    -- default programs to open on each workspace
    hl.exec_cmd(terminal, { workspace = "1 silent" })

    -- special cases where the window creation process is borked
    startup_workspace("vesktop", 7, 2, 3000)
    startup_workspace("google-chrome", 9, 10, 2000)
    hl.exec_cmd("vesktop")
    hl.exec_cmd("google-chrome-stable")

    -- move cursor to main monitor
    hl.timer(function() hl.dispatch(hl.dsp.focus({ workspace = 1 })) end, { timeout = 500, type = "oneshot" })
end)


-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "intl",

        follow_mouse = 2,

        numlock_by_default = true,
    },
})


-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + T",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",     hl.dsp.workspace.toggle_special("scratchpad_terminal"))
hl.bind(mainMod .. " + C",     hl.dsp.window.close())
hl.bind(mainMod .. " + M",     hl.dsp.exit())
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SPACE", hl.dsp.layout("togglesplit"))

-- focus / move window with arrows and hjkl
local dirs = { left = "left", H = "left", right = "right", L = "right", up = "up", K = "up", down = "down", J = "down" }
for key, dir in pairs(dirs) do
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ direction = dir }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ direction = dir }))
end

-- workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgb(d65d0e)", "rgb(af3a03)" }, angle = 45 },
            inactive_border = "rgb(665c54)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },

    dwindle = {
        preserve_split = true,
    },

    master = { new_status = "master" },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


--------------------
--- WINDOW RULES ---
--------------------

hl.window_rule({ match = { workspace = "special:scratchpad_terminal" }, float = true, size = "(monitor_w*0.5) (monitor_h*0.5)" })

hl.window_rule({ match = { class = "thunar", title = "Rename.*" }, float = true, stay_focused = true, move = "(cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5))" })

hl.window_rule({ match = { class = "Rofi" }, rounding = 0 })

hl.window_rule({ match = { class = "Aseprite" }, tile = true })

-- Unity's menus
hl.window_rule({ match = { class = "Unity", title = "Project Settings" }, min_size = "1280 720", center = true })
hl.window_rule({ match = { class = "Unity", title = "Preferences" },      min_size = "1280 720", center = true })
hl.window_rule({ match = { class = "Unity", title = "Select.*" },         stay_focused = true, move = "(monitor_w-(window_w)-12) (cursor_y-(window_h*0.5))" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.PopupWindowWithoutFocus" }, stay_focused = true, move = "monitor_w cursor_y" })
hl.window_rule({ match = { class = "Unity", title = "Curve" },            stay_focused = true, move = "(monitor_w-(window_w)-12) (cursor_y-(window_h*0.5))" })
hl.window_rule({ match = { class = "Unity", title = "Package Manager" },  min_size = "1024 768" })
hl.window_rule({ match = { class = "Unity", title = "Animation" },        min_size = "1024 768" })
hl.window_rule({ match = { class = "Unity", title = "Delete selected asset\\?" }, move = "(monitor_w*0.5)-(window_w*0.5) (monitor_h*0.5)-(window_h*0.5)" })

-- Steam's windows
hl.window_rule({ match = { class = "steam", title = "Friends List" },   float = true, center = true, size = "384 768" })
hl.window_rule({ match = { class = "steam", title = "Steam Settings" }, float = true, center = true, size = "1280 768" })

-- Steam games' windows
hl.window_rule({ match = { title = "The king is watching" }, min_size = "1920 1080" })

-- defaults
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({ name = "move-hyprland-run", match = { class = "hyprland-run" }, move = "20 monitor_h-120", float = true })
