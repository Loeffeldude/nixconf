local uv = vim.loop
local fs = vim.fs

vim.lsp.enable("roslyn_ls")

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
    "seblyng/roslyn.nvim",
    opts = {},
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
        roslyn_ls = {
          cmd = {
            "Microsoft.CodeAnalysis.LanguageServer",
            "--logLevel", -- this property is required by the server
            "Information",
            "--extensionLogDirectory", -- this property is required by the server
            fs.joinpath(uv.os_tmpdir(), "roslyn_ls/logs"),
            "--stdio",
          },
        },
      },
    },
  },
}
