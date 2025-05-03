
local function prompt_notify()
  vim.ui.input({ prompt = "Notification title: " }, function(title)
    if not title then
      vim.notify("Cancelled", vim.log.levels.WARN)
      return
    end

    vim.ui.input({ prompt = "Notification message (type +/y to use clipboard/register): " }, function(message)
      if not message then
        vim.notify("Cancelled", vim.log.levels.WARN)
        return
      end

      if message == "+" then
        message = vim.fn.getreg("+")
        if message == "" then
          vim.notify("Clipboard is empty", vim.log.levels.WARN)
          return
        end
      elseif message == "y" then
        message = vim.fn.getreg('"')
        if message == "" then
          vim.notify("Yank register is empty", vim.log.levels.WARN)
          return
        end
      end

      local script_path = vim.fn.expand("~") .. "/small-programming-projects/tools/send_notification.py"
      local cmd = string.format(
        "python3 %s -t %s -m %s",
        vim.fn.shellescape(script_path),
        vim.fn.shellescape(title),
        vim.fn.shellescape(message)
      )

      local output = vim.fn.system(cmd)
      vim.notify((output or ""):gsub("%s*$", ""), vim.log.levels.INFO)
    end)
  end)
end

-- Register the command and keybinding here
vim.api.nvim_create_user_command("PromptInput", prompt_notify, {})
vim.keymap.set("n", "<leader>n", ":PromptInput<CR>", { noremap = true, silent = true })

