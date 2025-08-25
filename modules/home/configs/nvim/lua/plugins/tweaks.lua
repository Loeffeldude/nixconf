return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[

⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢠⠃⡄⢿⣷⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡌⠀⠘⣸⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢹⡄⢀⡟⢳⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢦⣈⣿⣾⣾⡼⠀⠀⠀⠀⠀⠀
⠀⠀⢺⠀⢀⣺⣷⣿⣿⡧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣴⡻⣿⣿⣿⣗⠄⠀⠠⠆⠀⠀
⠀⠀⠀⣠⣭⣷⣿⣿⣿⣻⡧⣠⣤⣀⠀⠀
⠀⢠⣺⣿⣟⡿⡧⡏⣋⢕⢍⣿⢮⣝⣲⠤
⠈⠁⢉⡴⠛⠟⠛⣏⠉⠈⠳⡙⠂⠈⠙⠀

]],
        },
      },
      picker = {
        hidden = true,
        ignored = true,
      },
    },
  },
  {
    "gbprod/cutlass.nvim",
    opts = {
      -- your configuration comes here
      -- or don't set opts to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    -- change some options
    keys = {
      -- enable finding hidden/dot files
      {
        "<leader><leader>",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
        end,
        desc = "Find files (root dir)",
      },
      {
        "<leader>fa",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = false, file_ignore_patterns = {} })
        end,
        desc = "Find ALL files",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
        end,
        desc = "Find files (root dir)",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ cwd = false, hidden = true, no_ignore = true })
        end,
        desc = "Find files (cwd)",
      },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules/", ".git/", "__pycache__/", ".venv/", "vendor/" },
      },
    },
  },
}
