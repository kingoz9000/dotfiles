local function clean_tag_line()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd(lnum .. 's#<\\(\\w\\+\\)[^>]*>\\zs.\\{-}\\ze</\\1>##g')
end

vim.api.nvim_create_user_command('CleanTagLine', clean_tag_line, {})
vim.keymap.set('n', '<leader>cl', ':CleanTagLine<CR>', { noremap = true, silent = true })
