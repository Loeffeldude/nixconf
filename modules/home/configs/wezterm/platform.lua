local wezterm = require("wezterm")

local M = {}

function M.is_macos()
	return wezterm.target_triple == "aarch64-apple-darwin"
end

function M.setup(config)
	if M.is_macos() then
		config.font = wezterm.font("JetBrainsMono Nerd Font")
	else
		config.font = wezterm.font("Jetbrains Mono NF")
	end
	config.font_size = 12.0
	config.line_height = 0.95
	config.cell_width = 0.89
end

return M
