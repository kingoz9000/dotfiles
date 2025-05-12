return {
  "nvim-lua/plenary.nvim", -- dummy dependency to keep Lazy happy
  lazy = true,
  event = "BufReadPre",
  config = function()
    local function show_pydoc_for_word()
      local word = vim.fn.expand("<cword>")
      if not word or word == "" then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
      end

      local output = vim.fn.systemlist({ "pydoc", word })
      if vim.v.shell_error ~= 0 or not output or vim.tbl_isempty(output) then
        vim.notify("No pydoc found for '" .. word .. "'", vim.log.levels.INFO)
        return
      end

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

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

      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true })
    end

    vim.keymap.set("n", "<leader>pd", show_pydoc_for_word, { desc = "Show Python doc for word under cursor" })
  end,
}
