-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = false

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = "telescope"
local opt = vim.opt
opt.swapfile = false -- Disable swap files. They are annoying

opt.mouse = "" -- Disable mouse mode

vim.lsp.config("roslyn", {
  on_attach = function()
    print("This will run when the server attaches!")
  end,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})
