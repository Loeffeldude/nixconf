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
		key = "S",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PaneSelect,
	})

	if not is_macos then
		for i = 1, 9 do
			table.insert(config.keys, {
				key = tostring(i),
				mods = "ALT",
				action = wezterm.action({ ActivateTab = i - 1 }),
			})
		end
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
