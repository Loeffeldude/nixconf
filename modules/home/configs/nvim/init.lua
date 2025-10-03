vim.g.news = { lazyvim = false }
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- tries calling nixos parsers for treesitter
local ok, mymod = pcall(require, "parsers")
