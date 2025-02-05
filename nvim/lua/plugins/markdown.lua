return {
  -- Markdown Syntax Highlighting and Enhancements
  {
    "preservim/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 0     -- Enable folding
      vim.g.vim_markdown_conceal = 1              -- Enable concealing for better readability
      vim.g.vim_markdown_new_list_item_indent = 2 -- Proper indentation for lists
      vim.g.vim_markdown_auto_insert_bullets = 1  -- Auto-bullet continuation
    end,
  },

  -- Live Markdown Preview in Browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 0 -- Start preview manually
    end,
  },

  -- Terminal-based Markdown Preview (Glow)
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
  },

  -- Auto-Formatting for Markdown
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
      },
    },
  },
}

