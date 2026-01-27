local colors = require("colors")

local popup_off = "sketchybar --set apple.logo popup.drawing=off"

local menu_item_defaults = {
  background = {
    padding_left = 7,
    padding_right = 7,
    border_width = 0,
    drawing = "off",
  },
  padding_left = 0,
  padding_right = 0,
  icon = {
    padding_left = 10,
    padding_right = 10,
    color = colors.fg,
  },
  label = {
    padding_right = 10,
    color = colors.fg,
  },
}

sbar.add("item", "apple.logo", {
  position = "left",
  icon = {
    drawing = "off",
  },
  label = {
    string = "Menu",
    font = "SF Pro:Bold:14.0",
    color = colors.fg,
    padding_left = 12,
    padding_right = 12,
  },
  blur_radius = 30,
  background = {
    color = colors.transparent,
    border_color = colors.accent,
    border_width = 1,
    corner_radius = 8,
    height = 26,
    drawing = "on",
  },
  padding_left = 5,
  padding_right = 5,
  click_script = "sketchybar --set $NAME popup.drawing=toggle",
  popup = {
    background = {
      border_width = 1,
      corner_radius = 8,
      border_color = colors.accent,
      color = colors.bg,
    },
  },
})

local menu_items = {
  { name = "apple.prefs", icon = "", label = "System Settings", script = "open -a 'System Settings'" },
  { name = "apple.activity", icon = "", label = "Activity Monitor", script = "open -a 'Activity Monitor'" },
  { name = "apple.lock", icon = "", label = "Lock Screen", script = "pmset displaysleepnow" },
  { name = "apple.sleep", icon = "", label = "Sleep", script = "pmset sleepnow" },
  { name = "apple.restart", icon = "", label = "Restart", script = "osascript -e 'tell app \"System Events\" to restart'" },
  { name = "apple.shutdown", icon = "", label = "Shut Down", script = "osascript -e 'tell app \"System Events\" to shut down'" },
}

for _, item in ipairs(menu_items) do
  sbar.add("item", item.name, "popup.apple.logo", menu_item_defaults)
  sbar.set(item.name, {
    icon = item.icon,
    label = item.label,
    click_script = item.script .. "; " .. popup_off,
  })
end
