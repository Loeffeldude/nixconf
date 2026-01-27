local colors = require("colors")

sbar.add("item", "ram", {
  position = "right",
  update_freq = 2,
  icon = {
    string = "RAM",
    color = colors.green,
  },
})

sbar.subscribe("ram", "routine", function()
  sbar.exec("memory_pressure | grep 'System-wide memory free percentage:' | awk '{print 100-$5\"%\"}'", function(mem_usage)
    sbar.set("ram", {
      label = mem_usage
    })
  end)
end)
