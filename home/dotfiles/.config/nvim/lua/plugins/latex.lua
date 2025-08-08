return {
  {
    "lervag/vimtex",
    lazy = false, -- LaTeX functionality should be available immediately
    ft = { "tex", "latex" },
    config = function()
      vim.g.vimtex_view_method = "zathura" -- or another PDF viewer
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
    keys = {
      { "<leader>lc", "<cmd>VimtexCompile<cr>", desc = "LaTeX Compile" },
      { "<leader>lv", "<cmd>VimtexView<cr>", desc = "LaTeX View" },
      { "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "LaTeX TOC Toggle" },
      { "<leader>lk", "<cmd>VimtexStop<cr>", desc = "LaTeX Stop" },
      { "<leader>lK", "<cmd>VimtexStopAll<cr>", desc = "LaTeX Stop All" },
      { "<leader>lx", "<cmd>VimtexClean<cr>", desc = "LaTeX Clean" },
      { "<leader>lX", "<cmd>VimtexCleanAll<cr>", desc = "LaTeX Clean All" },
      { "<leader>li", "<cmd>VimtexInfo<cr>", desc = "LaTeX Info" },
      { "<leader>ll", "<cmd>VimtexLog<cr>", desc = "LaTeX Log" },
      { "<leader>lq", "<cmd>VimtexErrors<cr>", desc = "LaTeX Errors" },
      { "<leader>lr", "<cmd>VimtexReload<cr>", desc = "LaTeX Reload" },
      { "<leader>ls", "<cmd>VimtexStatus<cr>", desc = "LaTeX Status" },
      { "<leader>la", "<cmd>VimtexContextMenu<cr>", desc = "LaTeX Context Menu" },
    },
  },
  -- Add this if you want LSP support for LaTeX via texlab
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              -- Add any texlab-specific settings here
              build = {
                onSave = true,
              },
            },
          },
        },
      },
    },
  },
}
