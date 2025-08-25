local uv = vim.loop
local fs = vim.fs

return {
  {
    "williamboman/mason.nvim",
    enabled = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = true,
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
