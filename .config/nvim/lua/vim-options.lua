vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set("n", "<Esc>", function()
  vim.lsp.buf.clear_references()
  vim.cmd("nohlsearch")
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

vim.opt.termguicolors = true

-- Markdown Preview 
vim.api.nvim_set_keymap("n", "md", ":MarkdownPreview<CR>", { noremap = true, silent = true })

-- Custom command to delete text between <p> and </p>
vim.api.nvim_create_user_command('CleanTagLine', function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd(lnum .. 's#<\\(\\w\\+\\)[^>]*>\\zs.\\{-}\\ze</\\1>##g')
end, {})
vim.keymap.set('n', '<leader>cl', ':CleanTagLine<CR>', { noremap = true, silent = true })

vim.api.nvim_create_user_command('DiffWithFile', function()
  require("telescope.builtin").find_files({
    prompt_title = "Select file to diff with",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(bufnr)
        vim.cmd("vert diffsplit " .. entry.value)
      end)
      return true
    end,
  })
end, {})

vim.keymap.set('n', '<leader>d', ':DiffWithFile<CR>', { noremap = true, silent = true })
