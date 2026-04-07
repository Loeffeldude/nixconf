-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local function trigger_completion()
  local has_blink, blink = pcall(require, "blink.cmp")
  if has_blink then
    blink.show()
    return
  end

  local has_cmp, cmp = pcall(require, "cmp")
  if has_cmp then
    cmp.complete()
  end
end

vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<C-Space>", trigger_completion, { desc = "Trigger completion" })
vim.keymap.set("i", "<C-@>", trigger_completion, { desc = "Trigger completion" })
