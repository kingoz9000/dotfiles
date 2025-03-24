return {
  "kylechui/nvim-surround",
  version = "*",  -- Use the latest stable release
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({})
  end,
}

