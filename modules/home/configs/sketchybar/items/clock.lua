local colors = require("colors")

sbar.add("item", "clock", {
  position = "left",
  update_freq = 10,
  icon = {
    string = "󰥔",
    color = colors.accent,
  },
})

sbar.subscribe("clock", "routine", function()
  sbar.set("clock", {
    label = os.date("%a %d %b %H:%M")
  })
end)
