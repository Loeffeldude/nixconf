return {
	foreground = "#E0E0E0", -- Soft white for text
	background = "#0A1115", -- Very dark blue-green

	cursor_bg = "#C17B57", -- Warm glow color like the mountain light
	cursor_fg = "#0A1115", -- Dark background
	cursor_border = "#C17B57",

	selection_fg = "#0A1115",
	selection_bg = "#446677", -- Muted teal

	scrollbar_thumb = "#2D4F59", -- Dark teal
	split = "#1D3F49", -- Darker teal

	ansi = {
		"#0A1115", -- Black
		"#C17B57", -- Red (warm mountain glow)
		"#2D6B7C", -- Green (teal)
		"#8B9EA3", -- Yellow (muted)
		"#446677", -- Blue (muted teal)
		"#6A8CA1", -- Magenta (light teal)
		"#2D4F59", -- Cyan (dark teal)
		"#E0E0E0", -- White
	},
	brights = {
		"#1D3F49", -- Bright black
		"#E6A078", -- Bright red
		"#4B8699", -- Bright green
		"#ABC4CB", -- Bright yellow
		"#5B8799", -- Bright blue
		"#89ABC0", -- Bright magenta
		"#3E6B78", -- Bright cyan
		"#F0F0F0", -- Bright white
	},

	-- Keep the rest of your settings for copy mode and quick select
	copy_mode_active_highlight_bg = { Color = "#C17B57" },
	copy_mode_active_highlight_fg = { Color = "#0A1115" },
	copy_mode_inactive_highlight_bg = { Color = "#2D6B7C" },
	copy_mode_inactive_highlight_fg = { Color = "#0A1115" },

	quick_select_label_bg = { Color = "#C17B57" },
	quick_select_label_fg = { Color = "#0A1115" },
	quick_select_match_bg = { Color = "#2D6B7C" },
	quick_select_match_fg = { Color = "#0A1115" },
}
