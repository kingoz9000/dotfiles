return {
  -- Core DAP plugin
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Color and signs
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapStopped", {
      text = "➜",
      texthl = "DapStoppedHighlight",
      linehl = "",
      numhl = "",
    })

    vim.api.nvim_set_hl(0, 'DapStoppedLine', {
      bg = '#2a2e3a', -- subtle background for line highlight
    })

    vim.api.nvim_set_hl(0, 'DapStoppedHighlight', {
      fg = '#93c572',   -- arrow color
      bg = '#1a1b26',
      bold = true,
    })

    vim.fn.sign_define("DapStopped", {
      text = "➜",
      texthl = "DapStoppedHighlight", -- arrow color
      linehl = "DapStoppedLine",      -- line highlight
      numhl = "",                     -- optional: could use same as linehl
    })

      -- Keybindings
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue, { desc = "Start / Continue debugging" })
      map("n", "<F6>", dap.step_over, { desc = "Step over" })
      map("n", "<F7>", dap.step_into, { desc = "Step into" })
      map("n", "<F8>", dap.step_out, { desc = "Step out" })
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    end,
  },

  -- Python adapter
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local function get_python_path()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
          return venv .. "/bin/python"
        end

        -- Try pyenv
        local handle = io.popen("pyenv which python")
        if handle then
          local result = handle:read("*a")
          handle:close()
          result = result:gsub("%s+", "") -- trim newline
          if result ~= "" then return result end
        end

        return "/usr/bin/python3" -- fallback
      end

      require("dap-python").setup(get_python_path())
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              "scopes",
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "console", size = 0.5 },
              { id = "repl", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
          win_options = {
            winhighlight = "Normal:MyDapUIBackground,NormalNC:MyDapUIBackground",
          },
        },
      })
      vim.api.nvim_set_hl(0, "MyDapUIBackground", { bg = "#10131c" }) -- graphite

      vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function()
          local ft = vim.bo.filetype
          if ft == "dapui_scopes"
          or ft == "dapui_breakpoints"
          or ft == "dapui_stacks"
          or ft == "dapui_watches"
          or ft == "dapui_console"
          or ft == "dap-repl" then
          vim.api.nvim_win_set_option(0, "winhighlight", "Normal:MyDapUIBackground,NormalNC:MyDapUIBackground")
          end
        end,
      })

      -- Auto-open and close UI with debugging
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debugger UI" })
      vim.keymap.set("n", "<leader>de", function() dapui.eval() end, { desc = "Evaluate expression" })

      vim.keymap.set("n", "<leader>dx", function()
        vim.ui.input({ prompt = "Enter watch index to remove:" }, function(index)
          index = tonumber(index)
          if index then
            require("dapui").elements.watches.remove(index)
            vim.notify("Removed watch at index: " .. index)
          else
            vim.notify("Invalid index", vim.log.levels.ERROR)
          end
        end)
      end, { desc = "Remove watch by index" })

      vim.keymap.set("n", "<leader>dp", function()
        local dap = require("dap")
        if not dap.session() then
          vim.notify("No active debug session", vim.log.levels.WARN)
          return
        end

        vim.ui.input({ prompt = "Watch expression:" }, function(expr)
          if expr and expr ~= "" then
            require("dapui").elements.watches.add(expr) -- ✅ This adds it to the left panel
          end
        end)
      end, { desc = "DAP Add Watch Expression" })

    end,
  },
}

