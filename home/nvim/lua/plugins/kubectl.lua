return {
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup({})
    end,
    keys = {
      {
        "<leader>k",
        function()
          vim.cmd("vsplit")
          vim.cmd("vertical resize 70")
          require("kubectl").toggle({ tab = false })
        end,
        desc = "Toggle Kubernetes Sidebar",
      },
    },
  },
}
