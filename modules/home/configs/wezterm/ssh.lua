local M = {}

function M.setup(config)
	config.ssh_domains = {
		{
			name = "home",
			remote_address = "10.13.13.2",
			username = "loeffel",
			multiplexing = "None",
			assume_shell = "Posix",
		},
		{
			name = "home-local",
			remote_address = "192.168.0.126",
			username = "loeffel",
			multiplexing = "None",
			assume_shell = "Posix",
		},
	}
end

return M
