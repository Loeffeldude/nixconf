local uv = vim.loop
local fs = vim.fs

return {
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
        csharp_ls = {},
        clangd = {},
        -- roslyn_ls = {
        --   cmd = {
        --     "Microsoft.CodeAnalysis.LanguageServer",
        --     "--logLevel", -- this property is required by the server
        --     "Information",
        --     "--extensionLogDirectory", -- this property is required by the server
        --     fs.joinpath(uv.os_tmpdir(), "roslyn_ls/logs"),
        --     "--stdio",
        --   },
        -- },
      },
    },
  },
}
