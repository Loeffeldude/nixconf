local wezterm = require("wezterm")

local M = {}

function M.setup(config)
	local theme = require("colors.abstract")
	
	config.colors = theme
	config.audible_bell = "Disabled"
	config.freetype_load_target = "HorizontalLcd"
	
	config.use_fancy_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = true
	config.enable_wayland = false
	
	config.window_frame = {
		font = wezterm.font("Roboto"),
		font_size = 12,
	}
end

return M
