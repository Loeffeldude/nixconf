local colors = require("colors")

sbar.add("item", "volume", {
  position = "right",
  icon = {
    color = colors.magenta,
  },
})

local function update_volume()
  sbar.exec("osascript -e 'output volume of (get volume settings)'", function(volume)
    sbar.exec("osascript -e 'output muted of (get volume settings)'", function(muted)
      local vol = tonumber(volume)
      local icon = "󰕿"
      
      if muted == "true" then
        icon = "󰖁"
      elseif vol > 50 then
        icon = "󰕾"
      elseif vol > 0 then
        icon = "󰖀"
      end
      
      sbar.set("volume", {
        icon = icon,
        label = volume .. "%"
      })
    end)
  end)
end

sbar.subscribe("volume", "volume_change", update_volume)
