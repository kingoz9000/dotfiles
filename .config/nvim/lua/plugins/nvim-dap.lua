return {
  -- nvim-dap setup
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      -- Basic key mappings for debugging controls
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue debugging" })
      vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<F8>", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, { desc = "Clear breakpoints" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last" })

      -- Python Debugger Configuration using /usr/bin/python3
      dap.adapters.python = {
        type = "executable",
        command = "/usr/bin/python3",  -- Path to Python interpreter with debugpy installed
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",  -- This will launch the current file
          pythonPath = function()
            return "/usr/bin/python3"  -- Ensure it uses the global Python interpreter
          end,
        },
      }
    end,
  },

  -- nvim-dap-python setup
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    config = function()
      require("dap-python").setup("/usr/bin/python3") -- Path to Python interpreter with debugpy installed
    end,
  },

  -- nvim-dap-ui setup
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Setup dap-ui with improved defaults
      dapui.setup({
        layouts = {
          {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40, -- Adjust width for your display
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size = 10, -- Adjust height for better visibility
            position = "bottom",
          },
        },
      })

      -- Automatically open and close dap-ui with the lifecycle of dap events
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keybindings to manually toggle dap-ui or evaluate expression
      vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle Debugger UI" })
      vim.keymap.set("n", "<leader>de", function() dapui.eval() end, { desc = "Evaluate expression under cursor" })
    end,
  },
}

