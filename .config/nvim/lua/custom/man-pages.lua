local function show_manpage()
  local word = vim.fn.expand("<cword>")
  local sections = { "3", "2", "4", "7", "1" }

  -- Find first section that has a manpage
  local cmd
  for _, sec in ipairs(sections) do
    if vim.fn.system("man -w " .. sec .. " " .. word) ~= "" then
      cmd = { "man", sec, word }
      break
    end
  end

  if not cmd then
    vim.notify("No man page found for " .. word, vim.log.levels.WARN)
    return
  end

  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Run man inside terminal
  vim.fn.termopen(cmd, {
    on_exit = function()
      -- automatically close if man exits immediately
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_set_keymap(buf, "t", "q", "<C-\\><C-n>:bd!<CR>",
          { noremap = true, silent = true })
      end
    end,
  })

  -- Enter terminal mode so you can scroll with <C-d>, <C-u>, PgUp/PgDn, etc.
  vim.cmd("startinsert")

  -- Extra keymap: allow 'q' to quit like in real man
  vim.api.nvim_buf_set_keymap(buf, "t", "q", "<C-\\><C-n>:bd!<CR>", { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("ManPage", show_manpage, {})
vim.keymap.set("n", "<leader>m", ":ManPage<CR>", { noremap = true, silent = true })

