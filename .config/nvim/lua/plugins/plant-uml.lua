return {
  "aklt/plantuml-syntax",
  ft = { "plantuml", "puml" },
  config = function()
    local jar_path = vim.fn.expand("~/.local/share/plantuml/plantuml.jar")

    -- Generate PNG on save
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.puml",
      callback = function(args)
        local cmd = { "plantuml", args.file }
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function(_, code)
            if code == 0 then
              local img = args.file:gsub("%.puml$", ".png")
              vim.notify("✅ UML updated: " .. img, vim.log.levels.INFO)
            else
              vim.notify("❌ Failed to generate UML", vim.log.levels.ERROR)
            end
          end,
        })
      end,
    })

    -- Preview command
    vim.api.nvim_create_user_command("PlantUMLPreview", function()
      local img = vim.fn.expand("%:p"):gsub("%.puml$", ".png")
      vim.fn.jobstart({ "sxiv", "-a", img }, { detach = true })
    end, {})

    -- Keymap to open viewer
    vim.keymap.set("n", "<leader>up", ":PlantUMLPreview<CR>", {
      desc = "PlantUML: Open image in sxiv",
      silent = true,
    })
  end,
}

