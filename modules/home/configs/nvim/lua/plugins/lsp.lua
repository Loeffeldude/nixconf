return {
  {
    "folke/lazy.nvim",
    opts = {
      performance = {
        rtp = {
          disabled_plugins = {
            "mason",
            "mason-lspconfig",
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                onSave = true,
              },
            },
          },
        },
        rust_analyzer = {},
        gopls = {},
        tsserver = {
          settings = {
            typescript = {
              format = {
                indentSize = 2,
                convertTabsToSpaces = true,
              },
            },
          },
        },
        pyright = {},
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
        html = {},
        jsonls = {},
        marksman = {},
        omnisharp = {
          cmd = function()
            return { "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
          end,
        },
      },
    },
  },
}
