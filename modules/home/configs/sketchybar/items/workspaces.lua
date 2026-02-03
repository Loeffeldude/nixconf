local colors = require("colors")
local icons = require("helpers.icons")

sbar.add("event", "aerospace_workspace_change")

local function update_workspace_apps(workspace_id)
  sbar.exec("aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'", function(result)
    local icon_line = ""
    
    if result == "" then
      icon_line = " —"
    else
      local seen_apps = {}
      for app in result:gmatch("[^\n]+") do
        if app ~= "" and not seen_apps[app] then
          seen_apps[app] = true
          local icon = icons.get_app_icon(app)
          icon_line = icon_line .. " " .. icon
        end
      end
    end
    
    sbar.set("space." .. workspace_id, {
      label = workspace_id .. icon_line
    })
  end)
end

local function update_workspace_highlight(workspace_id, focused_workspace)
  if workspace_id == focused_workspace then
    sbar.set("space." .. workspace_id, {
      background = {
        border_color = colors.accent,
      },
      label = {
        color = colors.accent,
      },
    })
  else
    sbar.set("space." .. workspace_id, {
      background = {
        border_color = colors.fg,
      },
      label = {
        color = colors.fg,
      },
    })
  end
end

sbar.exec("sleep 2 && aerospace list-workspaces --all", function(result)
  for workspace_id in result:gmatch("[^\n]+") do
    sbar.add("item", "space." .. workspace_id, {
      position = "left",
      blur_radius = 30,
      background = {
        color = colors.transparent,
        border_color = colors.fg,
        border_width = 1,
        corner_radius = 8,
        height = 26,
        drawing = "on",
      },
      padding_left = 5,
      padding_right = 5,
      icon = {
        drawing = "off",
      },
      label = {
        string = workspace_id,
        padding_left = 12,
        padding_right = 12,
        font = "JetBrainsMono Nerd Font:Regular:14.0",
      },
      click_script = "aerospace workspace " .. workspace_id,
    })
    
    sbar.subscribe("space." .. workspace_id, "aerospace_workspace_change", function(env)
      update_workspace_highlight(workspace_id, env.FOCUSED_WORKSPACE)
      update_workspace_apps(workspace_id)
    end)
    
    update_workspace_apps(workspace_id)
  end
end)
