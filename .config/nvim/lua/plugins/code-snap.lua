return {
  "mistricky/codesnap.nvim",
  build = "make",
  lazy = false,
  config = function()
    require("codesnap").setup({
      mac_window_bar = false,
      save_path = "~/Desktop",
      code_font_family = "FiraCode Nerd Font",
      watermark = "",
      has_breadcrumbs = false,
      has_line_number = false,
      bg_padding = 1,
      bg_color = "#2B3038",
      rounded_corners = false,
    })

    -- Add visual mode keymap for screenshots
    vim.keymap.set("v", "<leader>ss", ":CodeSnap<CR>", { noremap = true, silent = true, desc = "CodeSnap Screenshot" })
  end,
}
