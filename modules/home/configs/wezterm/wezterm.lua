local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local platform = require("platform")
local appearance = require("appearance")
local keybindings = require("keybindings")
local projects = require("projects")
local ssh = require("ssh")

platform.setup(config)
appearance.setup(config)
keybindings.setup(config, platform.is_macos())
projects.setup()
ssh.setup(config)

return config
