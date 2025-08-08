return {
  {
    "neovim/nvim-lspconfig",
    event = "VimEnter",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      autoformat = true,
      servers = {
        arduino_language_server = {
          enabled = true,
          cmd = {
            "arduino-language-server",
            "-cli-config",
            vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
            "-fqbn",
            "arduino:megaavr:nona4809",
            "-cli",
            "arduino-cli",
            "-clangd",
            vim.fn.exepath("clangd"),
          },
          capabilities = {
            textDocument = {
              semanticTokens = false,
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "arduino-language-server",
        "clangd",
      },
    },
  },
}
