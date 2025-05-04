return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  config = function()
    require('dressing').setup({
      input = {
        enabled = true,
        default_prompt = "Rename to:",
        border = "rounded",
        win_options = {
          winblend = 10,
        },
        relative = "editor",
        prefer_width = 60,
      },
      select = {
        backend = { "builtin" },
        builtin = {
          border = "rounded",
          relative = "editor",
          anchor = "NW",
          width = 40,
          height = 2,
          max_height = 2,
          min_height = 2,
          win_options = {
            winblend = 10,
            cursorline = true,
          },
        },
      },
    })

    -- 🔁 Word-level substitution: :PromptSub or <leader>r
    vim.api.nvim_create_user_command("PromptSub", function()
      vim.ui.input({ prompt = "Word to replace: " }, function(from)
        if not from or from == "" then return end
        vim.ui.input({ prompt = "Replace with: " }, function(to)
          if not to then return end
          vim.cmd(string.format("%%s/\\<%s\\>/%s/g", from, to))
        end)
      end)
    end, {})

    vim.keymap.set("n", "<leader>w", function()
      vim.cmd("PromptSub")
    end, { desc = "Prompted word substitution", noremap = true, silent = true })

    -- 🔤 Character-level substitution: :PromptCharSub or <leader>c
    vim.api.nvim_create_user_command("PromptCharSub", function()
      vim.ui.input({ prompt = "Character to replace: " }, function(from)
        if not from or #from ~= 1 then
          vim.notify("Please enter a single character", vim.log.levels.WARN)
          return
        end
        vim.ui.input({ prompt = "Replace with: " }, function(to)
          if not to or #to ~= 1 then
            vim.notify("Please enter a single replacement character", vim.log.levels.WARN)
            return
          end
          vim.cmd(string.format("%%s/%s/%s/g", vim.fn.escape(from, "/\\"), vim.fn.escape(to, "/\\")))
        end)
      end)
    end, {})

    vim.keymap.set("n", "<leader>c", function()
      vim.cmd("PromptCharSub")
    end, { desc = "Prompted character substitution", noremap = true, silent = true })
  end,
}

