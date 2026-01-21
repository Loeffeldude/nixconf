local wezterm = require("wezterm")

local M = {}

local function list_projects()
	local projects = {}
	local base_path = os.getenv("HOME") .. "/Documents/projects/"

	local handle = io.popen('find "' .. base_path .. '" -maxdepth 2 -type d')

	if handle then
		local processed_dirs = {}
		for dir in handle:lines() do
			local relative_path = dir:sub(#base_path + 1)

			if relative_path ~= "" and not relative_path:match("^%.") then
				if not relative_path:match("/.*/") then
					table.insert(projects, {
						label = relative_path,
					})
				end
			end
		end

		handle:close()
	end

	return projects
end

local function open_project_in_new_tab(window, project_path)
	local full_path = os.getenv("HOME") .. "/Documents/projects/" .. project_path .. "/"
	local tab, pane, window = window:mux_window():spawn_tab({ cwd = full_path })
	pane:send_text("nvim .\n")
end

function M.setup()
	wezterm.on("augment-command-palette", function()
		return {
			{
				brief = "Dev project",
				icon = "md_application_braces_outline",
				action = wezterm.action.InputSelector({
					title = "project",
					action = wezterm.action_callback(function(window, pane, id, label)
						open_project_in_new_tab(window, label)
					end),
					choices = list_projects(),
					fuzzy = true,
				}),
			},
			{
				brief = "Dev Workspace Split",
				icon = "md_application_braces_outline",
				action = wezterm.action_callback(function(window, pane)
					pane:split({ direction = "Bottom", size = 0.3 })
					local bottom_pane = window:active_pane()
					bottom_pane:split({ direction = "Right", size = 0.33 })
					bottom_pane:split({ direction = "Right", size = 0.5 })
					pane.activate()
				end),
			},
		}
	end)
end

return M
