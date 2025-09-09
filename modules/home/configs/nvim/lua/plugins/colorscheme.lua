return {
  {
    "armannikoyan/rusty",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      underline_current_line = true,
      colors = {
        foreground = "#c5c8c6",
        background = "#373b41",
        selection = "#373b41",
        line = "#282a2e",
        comment = "#969896",
        red = "#cc6666",
        orange = "#de935f",
        yellow = "#f0c674",
        green = "#b5bd68",
        aqua = "#8abeb7",
        blue = "#81a2be",
        purple = "#b294bb",
        window = "#4d5057",
      },
    },
    config = function(_, opts)
      require("rusty").setup(opts)
      vim.cmd("colorscheme rusty")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("nightfox").setup({
        -- Optional customization
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = true, -- Disable setting background
          terminal_colors = false, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false, -- Non focused panes set to alternative background
          styles = { -- Style to be applied to different syntax groups
          },
          inverse = { -- Inverse highlight for different types
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })

      -- vim.cmd("colorscheme carbonfox") -- You can choose: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "dragon", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        -- Customize options here
        style = "dark", -- 'dark' or 'light'
        transparent = false,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = false,
        color_overrides = {
          -- Add any color overrides here
        },
        group_overrides = {
          -- Add any highlight group overrides here
        },
      })
    end,
  },
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin", enabled = false },
  { "LazyVim/LazyVim", opts = {
    colorscheme = "rusty",
  } },
}
