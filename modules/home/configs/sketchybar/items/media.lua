sbar.add("item", "media", {
  position = "left",
  update_freq = 5,
  label = {
    max_chars = 40,
  },
  scroll_texts = "off",
  updates = "on",
})

local function update_media()
  sbar.exec("pgrep -x Spotify", function(result)
    if result == "" then
      sbar.set("media", { drawing = "off" })
      return
    end
    
    sbar.exec("osascript -e 'tell application \"Spotify\" to player state as string'", function(state)
      if state:match("playing") then
        sbar.exec("osascript -e 'tell application \"Spotify\" to name of current track'", function(track)
          sbar.exec("osascript -e 'tell application \"Spotify\" to artist of current track'", function(artist)
            sbar.set("media", {
              label = track .. " - " .. artist,
              drawing = "on",
            })
          end)
        end)
      else
        sbar.set("media", { drawing = "off" })
      end
    end)
  end)
end

sbar.subscribe("media", { "routine", "media_change" }, update_media)
