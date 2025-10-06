return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- existing
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,

        -- ✅ clang-format WITH style (INSIDE sources!)
        null_ls.builtins.formatting.clang_format.with({
          extra_args = {
            '--style={BasedOnStyle: LLVM, AllowShortIfStatementsOnASingleLine: true, AllowShortLoopsOnASingleLine: true, AllowShortBlocksOnASingleLine: Empty, BreakBeforeBraces: Attach}',
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
        }),
      },
    })

    -- Format Python with null-ls
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        vim.lsp.buf.format({
          async = false,
          filter = function(c) return c.name == "null-ls" end,
        })
      end,
    })

    -- ✅ Format C/C++ with null-ls (not clangd)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.m", "*.mm" },
      callback = function()
        vim.lsp.buf.format({
          async = false,
          filter = function(c) return c.name == "null-ls" end,
        })
      end,
    })

    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.format({ async = true })
    end, {})
  end,
}

