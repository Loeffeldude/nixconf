local colors = require("colors")

return {
  init = function()
    sbar.bar({
      height = 28,
      position = "top",
      padding_left = 6,
      padding_right = 6,
      color = colors.transparent,
      blur_radius = 0,
      drawing = "on",
    })

    sbar.default({
      icon = {
        font = "Hack Nerd Font:Bold:12.0",
        color = colors.fg,
        padding_left = 6,
        padding_right = 3,
      },
      label = {
        font = "SF Pro:Medium:12.0",
        color = colors.fg,
        padding_left = 3,
        padding_right = 6,
      },
      padding_left = 2,
      padding_right = 2,
      blur_radius = 30,
      background = {
        color = colors.panel,
        corner_radius = 6,
        height = 22,
        drawing = "on",
      },
    })
  end,
}
