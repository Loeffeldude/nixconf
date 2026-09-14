local vars = require("vars")

local mainMod = "SUPER"
local terminal = "wezterm start"

local function dispatch(command)
  return hl.dsp.exec_cmd("hyprctl dispatch " .. command)
end

hl.monitor({
  output = "DP-1",
  mode = "1920x1080@100",
  position = "1920x0",
  scale = 1,
})

hl.monitor({
  output = "DP-3",
  mode = "1920x1080@100",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "0", default = true })
hl.workspace_rule({ workspace = "2", monitor = "0" })
hl.workspace_rule({ workspace = "3", monitor = "0" })
hl.workspace_rule({ workspace = "4", monitor = "0" })
hl.workspace_rule({ workspace = "5", monitor = "1", default = true })
hl.workspace_rule({ workspace = "6", monitor = "1" })
hl.workspace_rule({ workspace = "7", monitor = "1" })
hl.workspace_rule({ workspace = "8", monitor = "1" })

hl.on("hyprland.start", function()
  hl.exec_cmd("eww daemon && eww open bar0 && eww open bar1")
  hl.exec_cmd("dunst")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd(vars.polkit_agent)
  hl.exec_cmd("wl-paste --type text --watch cliphist store &")
  hl.exec_cmd("wl-paste --type image --watch cliphist store &")
end)

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")

hl.config({
  general = {
    gaps_in = 8,
    gaps_out = 8,
    border_size = 1,
    col = {
      active_border = "rgba(de935faa)",
      inactive_border = "rgba(4d505780)",
    },
    layout = "dwindle",
    resize_on_border = true,
  },
  decoration = {
    rounding = 6,
    active_opacity = 1.0,
    inactive_opacity = 0.96,
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
    },
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(0f0f0fee)",
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
    smart_split = false,
  },
  master = {
    new_status = "master",
  },
  input = {
    kb_layout = "de",
    kb_options = "caps:escape",
    follow_mouse = 0,
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      middle_button_emulation = true,
    },
    repeat_delay = 400,
    repeat_rate = 60,
    sensitivity = 0,
  },
  cursor = {
    no_hardware_cursors = true,
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    vrr = 0,
    middle_click_paste = false,
    focus_on_activate = false,
  },
})

hl.curve("smooth", {
  type = "bezier",
  points = {
    { 0.25, 0.1 },
    { 0.25, 1.0 },
  },
})

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smooth", style = "slidevert" })

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("pwmenu"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send \"Screenshot\" \"Copied to clipboard\""))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send \"Screenshot\" \"Saved to ~/Pictures\""))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + h", dispatch("movecurrentworkspacetomonitor l"))
hl.bind(mainMod .. " + CTRL + l", dispatch("movecurrentworkspacetomonitor r"))

for workspace = 1, 9 do
  local key = tostring(workspace)
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

hl.window_rule({
  name = "windowrule-1",
  float = true,
  match = { class = "^(pavucontrol)$" },
})

hl.window_rule({
  name = "windowrule-2",
  float = true,
  match = { class = "^(nm-connection-editor)$" },
})

hl.window_rule({
  name = "windowrule-3",
  float = true,
  match = { class = "^(blueberry.py)$" },
})

hl.window_rule({
  name = "windowrule-4",
  float = true,
  match = { class = "^(blueman-manager)$" },
})

hl.window_rule({
  name = "windowrule-5",
  float = true,
  pin = true,
  match = { title = "^(Picture-in-Picture)$" },
})

hl.window_rule({
  name = "windowrule-6",
  opacity = "0.0 override",
  no_anim = true,
  no_focus = true,
  no_initial_focus = true,
  match = { class = "^(xwaylandvideobridge)$" },
})

hl.window_rule({
  name = "windowrule-7",
  tile = true,
  match = {
    class = "^(Godot)$",
    title = "^(Godot)(.*)$",
  },
})

hl.window_rule({
  name = "windowrule-8",
  float = true,
  match = {
    class = "^(Godot)$",
    title = "^(?!Godot)(.*)$",
  },
})
