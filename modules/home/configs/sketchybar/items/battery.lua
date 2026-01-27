local colors = require("colors")

sbar.add("item", "battery", {
  position = "right",
  update_freq = 30,
  icon = {
    color = colors.yellow,
  },
})

local function update_battery()
  sbar.exec("pmset -g batt", function(result)
    local percentage = result:match("(%d+)%%")
    local charging = result:match("AC Power")
    
    if not percentage then
      return
    end
    
    local icon = "󰁺"
    local pct = tonumber(percentage)
    
    if charging then
      icon = "󰂄"
    elseif pct > 80 then
      icon = "󰁹"
    elseif pct > 60 then
      icon = "󰂀"
    elseif pct > 40 then
      icon = "󰁾"
    elseif pct > 20 then
      icon = "󰁼"
    end
    
    sbar.set("battery", {
      icon = icon,
      label = percentage .. "%"
    })
  end)
end

sbar.subscribe("battery", { "routine", "system_woke", "power_source_change" }, update_battery)
