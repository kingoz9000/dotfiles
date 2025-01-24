return {
    "nvim-lua/plenary.nvim", -- Include any dependency (optional)
    config = function()
        -- Enable both absolute and relative line numbers
        vim.o.number = true
        vim.o.relativenumber = true

        -- Optional: Keybinding to toggle relative line numbers
        vim.api.nvim_set_keymap("n", "<F4>", ":set relativenumber!<CR>", { noremap = true, silent = true })
    end,
}

