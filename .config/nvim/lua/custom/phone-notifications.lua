local function prompt_notify()
  local devices = { "Iphone", "Boox" }

  vim.ui.select(devices, {
    prompt = "Select device to send notification to:",
    builtin = { height = 2 },
  }, function(device)
    if not device then
      vim.notify("Cancelled", vim.log.levels.WARN)
      return
    end

    vim.ui.input({ prompt = "Notification title: " }, function(title)
      if not title or title == "" then
        vim.notify("Cancelled", vim.log.levels.WARN)
        return
      end

      vim.ui.input({ prompt = "Notification message (+ for clipboard, y for yank): " }, function(message)
        if not message or message == "" then
          vim.notify("Cancelled", vim.log.levels.WARN)
          return
        end

        local script_path = vim.fn.expand("~") .. "/small-programming-projects/tools/send_notification.py"

        if message == "+" then
          -- Try to get text first (may fail silently if not text)
          local ok, reg = pcall(vim.fn.getreg, "+")
            if ok and reg ~= "" then
              message = reg
            else
            -- Try dumping image instead
            local tmp_image_path = "/tmp/clipboard_image.png"
            vim.fn.system("xclip -selection clipboard -t image/png -o > " .. tmp_image_path)

            if vim.fn.filereadable(tmp_image_path) == 1 then
              local cmd = string.format(
                "python3 %s -t %s -d %s --image %s",
                vim.fn.shellescape(script_path),
                vim.fn.shellescape(title),
                vim.fn.shellescape(device),
                vim.fn.shellescape(tmp_image_path)
              )

              local output = vim.fn.system(cmd)
              os.remove(tmp_image_path)
              vim.notify((output or ""):gsub("%s*$", ""), vim.log.levels.INFO)
              return
            else
              vim.notify("Clipboard is empty (no text or image)", vim.log.levels.WARN)
              return
            end
          end
        elseif message == "y" then
          message = vim.fn.getreg('"')
          if message == "" then
            vim.notify("Yank register is empty", vim.log.levels.WARN)
            return
          end
        end

        local is_url = message:match("^https?://") or message:match("^www%.")
        local is_img = message:lower():match("^https?://.*%.(jpg|jpeg|png|gif)%f[%W]")
        local tmp_image_path = "/tmp/clipboard_image.png"
        local cmd

        if is_img then
          vim.fn.system("xclip -selection clipboard -t image/png -o > " .. tmp_image_path)

          if vim.fn.filereadable(tmp_image_path) == 1 then
            cmd = string.format(
              "python3 %s -t %s -d %s -i %s",
              vim.fn.shellescape(script_path),
              vim.fn.shellescape(title),
              vim.fn.shellescape(device),
              vim.fn.shellescape(tmp_image_path)
            )

            local output = vim.fn.system(cmd)
            os.remove(tmp_image_path)
            vim.notify((output or ""):gsub("%s*$", ""), vim.log.levels.INFO)
            return
          else
            vim.notify("No image found in clipboard.", vim.log.levels.WARN)
            return
          end
        elseif is_url then
          cmd = string.format(
            "python3 %s -d %s -t %s -u %s",
            vim.fn.shellescape(script_path),
            vim.fn.shellescape(device),
            vim.fn.shellescape(title),
            vim.fn.shellescape(message)
          )
        else
          cmd = string.format(
            "python3 %s -d %s -t %s -m %s",
            vim.fn.shellescape(script_path),
            vim.fn.shellescape(device),
            vim.fn.shellescape(title),
            vim.fn.shellescape(message)
          )
        end

        local output = vim.fn.system(cmd)
        vim.notify((output or ""):gsub("%s*$", ""), vim.log.levels.INFO)
      end)
    end)
  end)
end

vim.api.nvim_create_user_command("PromptInput", prompt_notify, {})
vim.keymap.set("n", "<leader>n", ":PromptInput<CR>", { noremap = true, silent = true })

