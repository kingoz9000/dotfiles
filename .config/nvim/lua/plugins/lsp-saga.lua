return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({
      symbol_in_winbar = {
        enable = false,
      },
      ui = {
        border = "rounded",
        code_action = "",
      },
      lightbulb = {
        enable = true,
        sign = true,
        virtual_text = true,
      },
      finder = {
        keys = {
          open = "o",
          vsplit = "v",
          split = "s",
          quit = "q",
        },
      },
    })

    -- Keybindings
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
    vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
    vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
    vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional but recommended
    "nvim-tree/nvim-web-devicons" -- optional for icons
  },
}

