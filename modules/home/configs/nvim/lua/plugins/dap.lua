return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
        opts = {},
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "mason-org/mason.nvim",
        },
        opts = {
          automatic_installation = true,
          ensure_installed = {
            "netcoredbg",
          },
          handlers = {},
        },
      },
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
      {
        "<leader>dx",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

      local function get_dotnet_dll()
        return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
      end

      dapui.setup()

      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "C", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })

      dap.adapters.coreclr = {
        type = "executable",
        command = mason_bin .. "/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch project",
          request = "launch",
          program = get_dotnet_dll,
          cwd = "${workspaceFolder}",
        },
      }

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
