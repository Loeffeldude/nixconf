local uv = vim.loop
local fs = vim.fs

return {
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = {},
      },
    },
  },
  {
    "seblyng/roslyn.nvim",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {},
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
        gopls = {
          settings = {
            gopls = {
              usePlaceholders = false,
            },
          },
        },
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
        phpactor = {
          enabled = false,
        },
        intelephense = {
          enabled = true,
          settings = {},
          cmd = { "intelephense", "--stdio" },
          filetypes = { "php" },
        },
        -- laravel_ls = {},
        -- pylsp = {
        --   --   settings = {
        --   --     pylsp = {
        --   --       plugins = {
        --   --         rope_autoimport = {
        --   --           enabled = true,
        --   --         },
        --   --       },
        --   --     },
        --   --   },
        --   -- },
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
        clangd = {},
      },
    },
  },
}
