local colors = require("colors")

sbar.add("item", "cpu", {
  position = "right",
  update_freq = 2,
  icon = {
    string = "CPU",
    color = colors.cyan,
  },
})

sbar.subscribe("cpu", "routine", function()
  sbar.exec("ps -eo pcpu,user | awk 'NR>1 {sum+=$1} END {print int(sum)}'", function(cpu_usage)
    sbar.set("cpu", {
      label = cpu_usage .. "%"
    })
  end)
end)
