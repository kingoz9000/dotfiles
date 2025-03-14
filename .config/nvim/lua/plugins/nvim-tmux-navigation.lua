return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    require('nvim-tmux-navigation').setup({})
    vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
    vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
    vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
    vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
    vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:silent !tmux split-window -v "source $VIRTUAL_ENV/bin/activate; python3 %; echo \\"Press Enter to close...\\"; read -r dummy"<CR>', { noremap = true, silent = true })

  end,
}
