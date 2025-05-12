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

vim.wo.number = true

vim.opt.termguicolors = true

-- Markdown Preview 
vim.api.nvim_set_keymap("n", "md", ":MarkdownPreview<CR>", { noremap = true, silent = true })
-- Custom command to clean between html tags
require("custom.clean-tag-line")
-- Custom command to diff a file
require("custom.diff-with-file")
-- Custom command to run a Python script that sends a notification
require("custom.phone-notifications")
-- Custom command to run a script that sets up a static and templates directories etc...
require("custom.create-web-dir")
