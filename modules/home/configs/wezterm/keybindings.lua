local wezterm = require("wezterm")

local M = {}

function M.setup(config, is_macos)
	config.keys = {}

	if is_macos then
		table.insert(config.keys, { 
			key = "/", 
			mods = "SHIFT|ALT", 
			action = wezterm.action({ SendString = "\\" }) 
		})
	end

	table.insert(config.keys, {
		key = "Space",
		mods = "CTRL",
		action = wezterm.action({ SendString = "\x00" }),
	})

	table.insert(config.keys, {
		key = "S",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PaneSelect,
	})

	local tab_number_mods = is_macos and "SUPER" or "CTRL"

	for i = 1, 9 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = tab_number_mods,
			action = wezterm.action({ ActivateTab = i - 1 }),
		})
	end

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
end

return M
