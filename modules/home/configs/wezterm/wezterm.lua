local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local ai_plugin = wezterm.plugin.require(
	"https://github.com/Michal1993r/ai-helper.wezterm?ref=199dcc4c714c5edee70f3868735c1e8ee44eb116"
)
ai_plugin.apply_to_config(config, {
	type = "ollama",
	ollama_path = "ollama", -- or full path like "/usr/local/bin/ollama"
	model = "llama2", -- or any model you have installed
})

local theme = require("colors.abstract")

local function list_projects()
	local projects = {}
	local base_path = os.getenv("HOME") .. "/Documents/projects/"

	local handle = io.popen('find "' .. base_path .. '" -maxdepth 2 -type d')

	if handle then
		local processed_dirs = {}
		for dir in handle:lines() do
			local relative_path = dir:sub(#base_path + 1)

			-- Skip base directory and hidden directories
			if relative_path ~= "" and not relative_path:match("^%.") then
				-- Check if it's directly in projects or one level deep
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

config.colors = theme
config.audible_bell = "Disabled"
config.background = {
	{
		source = {
			File = "/home/loeffel/.config/wezterm/background.png",
		},
		hsb = {
			brightness = 0.02,
			hue = 1,
			saturation = 0.1,
		},
		opacity = 1,
	},
}
config.font = wezterm.font("Jetbrains Mono NF")

config.keys = {
	{ key = "S", mods = "CTRL|SHIFT", action = wezterm.action.PaneSelect },
}
-- Tab switching using Alt + number keys (works well for German layout)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = wezterm.action({ ActivateTab = i - 1 }),
	})
end

-- Next and previous tab navigation
table.insert(config.keys, {
	key = "Tab",
	mods = "CTRL",
	action = wezterm.action({ ActivateTabRelative = 1 }),
})
table.insert(config.keys, {
	key = "Tab",
	mods = "SHIFT|CTRL",
	action = wezterm.action({ ActivateTabRelative = -1 }),
})

-- Move tabs left and right
table.insert(config.keys, {
	key = "PageUp",
	mods = "SHIFT|CTRL",
	action = wezterm.action({ MoveTabRelative = -1 }),
})
table.insert(config.keys, {
	key = "PageDown",
	mods = "SHIFT|CTRL",
	action = wezterm.action({ MoveTabRelative = 1 }),
})

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.enable_wayland = false
config.window_frame = {
	font = require("wezterm").font("Roboto"),
	font_size = 12,
}
return config
