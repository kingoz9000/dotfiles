return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  config = function()
    require('dressing').setup({
      input = {
        enabled = true,
        default_prompt = "Rename to:",
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },
    })
  end
}

