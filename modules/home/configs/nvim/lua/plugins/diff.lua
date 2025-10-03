return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView File History" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
      { "<leader>gr", "<cmd>DiffviewRefresh<cr>", desc = "DiffView Refresh" },
      { "<leader>gf", "<cmd>DiffviewToggleFiles<cr>", desc = "DiffView Toggle Files" },
    },
    opts = {
      enhanced_diff_hl = true, -- Better syntax highlighting
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
      hooks = {
        diff_buf_read = function()
          -- Disable for diff buffers
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    },
  },
}
