return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set("n", "<C-n>", ":Neotree toggle <CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

    local neo_tree = require("neo-tree")
    local hidden_visible = false

    -- Function to toggle hidden files
    local function toggle_hidden_files()
      hidden_visible = not hidden_visible

      -- Close Neo-tree before updating settings
      vim.cmd("Neotree close")

      -- Apply new settings
      neo_tree.setup({
        filesystem = {
          filtered_items = {
            visible = hidden_visible,
            hide_dotfiles = not hidden_visible,
            hide_gitignored = not hidden_visible,
            hide_hidden = not hidden_visible,
          },
        },
      })

      -- Reopen Neo-tree to apply new settings
      vim.cmd("Neotree show")
    end

    -- Set keybinding to toggle hidden files
    vim.keymap.set("n", "<leader>h", toggle_hidden_files, { desc = "Toggle Hidden Files in Neo-tree" })

    -- Default setup
    neo_tree.setup({
      filesystem = {
        filtered_items = {
          visible = hidden_visible,
          hide_dotfiles = not hidden_visible,
          hide_gitignored = not hidden_visible,
          hide_hidden = not hidden_visible,
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      }
    })
  end,
}

