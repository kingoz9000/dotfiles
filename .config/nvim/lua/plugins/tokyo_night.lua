return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000, -- Load it early
  config = function()
    vim.cmd("colorscheme tokyonight")
  end,
}

