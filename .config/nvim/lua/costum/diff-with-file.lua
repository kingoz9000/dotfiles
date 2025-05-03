local function diff_with_file()
  require("telescope.builtin").find_files({
    prompt_title = "Select file to diff with",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(bufnr)
        vim.cmd("vert diffsplit " .. entry.value)
      end)
      return true
    end,
  })
  end

vim.api.nvim_create_user_command('DiffWithFile', diff_with_file, {})
vim.keymap.set('n', '<leader>d', ':DiffWithFile<CR>', { noremap = true, silent = true })
