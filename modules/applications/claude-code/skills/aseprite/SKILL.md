---
name: aseprite
description: Create, edit, inspect or export pixel art with Aseprite. Use for drawing or changing sprites, live-editing the sprite open in the user's Aseprite window (claude-bridge), and command-line work on .aseprite files such as spritesheets, palettes, recolors and batch exports.
---

# Aseprite

- **Live bridge**: edit the sprite open in the user's window.
- **Command line**: files on disk, exports and batch work.

Use the bridge when the user wants to watch or edit along; otherwise the command line.

## Live bridge

The user starts it with File > Scripts > claude-bridge and stops it by closing
the dialog. You can't start it. If it isn't running, ask the user to start it.

Files are in `$XDG_RUNTIME_DIR/aseprite-claude/`:

- `request.lua`: what you send
- `response.txt`: `ready` just after startup, then the last request's id, `ok` or `error`, and output
- `preview.png`: the active frame, enlarged, after each request

These files remain after the bridge stops, so only a reply with your id proves
it is running. Remove an unanswered request so it can't linger, then ask the user.

### Sending a request

First line: `-- id: <unique id>`. Optional second line: `-- raw`, which skips
the transaction (use it for read-only queries and creating sprites). Write to a
temporary file, then rename it:

```bash
D=$XDG_RUNTIME_DIR/aseprite-claude; ID=draw-$(date +%s%N)
{ echo "-- id: $ID"; cat <<'LUA'
local s = app.sprite
assert(s and s.filename == "Sprite-0001", "wrong sprite")
assert(app.layer and app.layer.isEditable, "layer not editable")
local image = Image(s.spec)
image:clear()
if app.cel then image:drawImage(app.cel.image, app.cel.position) end
image:drawPixel(4, 4, Color{ r = 250, g = 189, b = 47 })
s:newCel(app.layer, app.frame, image, Point(0, 0))
LUA
} > $D/r.tmp && mv $D/r.tmp $D/request.lua
for i in $(seq 40); do [ "$(head -1 $D/response.txt)" = "$ID" ] && break; sleep 0.25; done
[ "$(head -1 $D/response.txt)" = "$ID" ] && sleep 1 && cat $D/response.txt || { rm -f $D/request.lua; echo "no reply"; }
```

Send one request at a time. Read `preview.png` after each edit and fix what looks wrong.

### Rules

- Query the active sprite first (raw request), and assert it in every edit. Edits
  go to whichever sprite is active.
- Keep edits undoable: draw on a new or cloned image, then use `sprite:newCel` or
  assign `cel.image`. Direct `drawPixel` on a cel's image can't be undone or
  rolled back. Don't use `-- raw` for edits.
- `isModified` doesn't reflect edits made in the same request.
- Don't save or overwrite files unless asked. `saveAs` is reachable, so be careful.
- Requests run on an allowlist: no `io`, `os`, `app.fs`, `app.open`, `setmetatable`
  and so on. Never work around it; ask the user before widening it.
- If the user reports permission prompts, stop sending and remove `request.lua`.

Bridge source: `~/.dotfiles/modules/applications/aseprite/claude-bridge.lua`.
Restart the bridge to pick up changes. Keep it at its current path, since Aseprite
ties the saved full trust to the script. Never access files from a Timer without
stopping it first: that once flooded the user with prompts. Keep this skill in sync.

## Command line

```bash
aseprite -b --script-param key=value --script file.lua   # params go before the script
aseprite -b in.aseprite --scale 16 --save-as preview.png
aseprite -b in.aseprite --sheet out.png --data out.json --format json-array --list-tags
```

- Scripts read params from `app.params`.
- Put throwaway scripts and previews in the scratchpad.
- Export an enlarged PNG, look at it, and fix what looks wrong.
- Save to a new file unless asked to edit in place. Before editing in place, have
  the user save and close the sprite: an open copy doesn't reload, and saving it
  would overwrite the changes.
