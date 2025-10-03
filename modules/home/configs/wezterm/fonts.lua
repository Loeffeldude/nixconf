local wezterm = require("wezterm")

function apply_to_config(config)
	if wezterm.target_triple == "" then
		config.font = wezterm.font("JetBrains Mono")
	else
		config.font = wezterm.font("Jetbrains Mono NF")
	end
end
