return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = {
      view = "cmdline_popup",
    },
    views = {
      cmdline_popup = {
        position = {
          row = "90%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)

    -- Macro recording notification
    local notify = require("notify")
    notify.setup({
      background_colour = "#000000",
      stages = "static",
      render = "minimal",
      timeout = 2000,
    })

    local macro_notify_id = nil

    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        macro_notify_id = notify("Recording macro...", vim.log.levels.INFO, {
          timeout = false,
        })
      end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        if macro_notify_id then
          notify.dismiss({ id = macro_notify_id, silent = true })
          macro_notify_id = nil
        end
      end,
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}

