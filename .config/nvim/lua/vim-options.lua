vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')
vim.keymap.set("n", "<Esc>", function()
  vim.lsp.buf.clear_references()
  vim.cmd("nohlsearch")
end, { noremap = true, silent = true })

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.termguicolors = true

-- Disable automatic comment continuation in C and C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})


-- Markdown Preview 
vim.api.nvim_set_keymap("n", "md", ":MarkdownPreview<CR>", { noremap = true, silent = true })
-- extra go to end of line
vim.api.nvim_set_keymap("n", "½", "$", { noremap = true, silent = true })
-- Custom command to clean between html tags
require("custom.clean-tag-line")
-- Custom command to diff a file
require("custom.diff-with-file")
-- Custom command to run a script that sets up a static and templates directories etc...
require("custom.create-web-dir")
-- Custom command to run a script that shows man pages
require("custom.man-pages")
