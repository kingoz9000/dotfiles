return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",  -- ensures it loads when you open a file
    config = function()
      require("gitsigns").setup()

      -- Preview current hunk
      vim.keymap.set("n", "<leader>gp", function()
        require("gitsigns").preview_hunk()
      end, { desc = "Preview Git hunk", noremap = true, silent = true })

      -- Toggle line blame
      vim.keymap.set("n", "<leader>gt", function()
        require("gitsigns").toggle_current_line_blame()
      end, { desc = "Toggle Git blame", noremap = true, silent = true })

      -- Stage current hunk
      vim.keymap.set("n", "<leader>gs", function()
        require("gitsigns").stage_hunk()
      end, { desc = "Stage Git hunk", noremap = true, silent = true })

      -- Undo stage current hunk
      vim.keymap.set("n", "<leader>gu", function()
        require("gitsigns").undo_stage_hunk()
      end, { desc = "Undo stage Git hunk" })
      -- Reset current hunk
      vim.keymap.set("n", "<leader>gr", function()
        require("gitsigns").reset_hunk()
      end, { desc = "Reset Git hunk", noremap = true, silent = true })

      -- Stage entire buffer
      vim.keymap.set("n", "<leader>gS", function()
  require("gitsigns").stage_buffer()
      end, { desc = "Stage entire buffer" })

      -- Git diff
      vim.keymap.set("n", "<leader>gd", function()
        require("gitsigns").diffthis()
      end, { desc = "Diff against index" })

      -- Hunk jumping
      vim.keymap.set("n", "]h", function()
        require("gitsigns").next_hunk()
      end, { desc = "Next Git hunk" })

      vim.keymap.set("n", "[h", function()
        require("gitsigns").prev_hunk()
      end, { desc = "Previous Git hunk" })

      -- Color changes
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00", bold = true })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ffaa00", bold = true })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff4444", bold = true })
    end,
  }
}

