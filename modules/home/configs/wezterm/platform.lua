local wezterm = require("wezterm")

local M = {}

function M.is_macos()
	return wezterm.target_triple == "aarch64-apple-darwin"
end

function M.setup(config)
	if M.is_macos() then
		config.font = wezterm.font("Noto Mono")
	else
		config.font = wezterm.font("Jetbrains Mono NF")
	end
end

return M
