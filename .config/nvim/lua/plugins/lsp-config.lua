return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "clangd",
        "lua_ls",
        "html",
        "pyright",
        "cssls",
        "ts_ls",
      },
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.colorProvider = true
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
        vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
        vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
        vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
      end

      lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        before_init = function(params, config)
          local Path = util.path
          local cwd = vim.fn.getcwd()
          local python_path = vim.fn.system('pyenv which python'):gsub("\n", "")
          if Path.is_file(Path.join(cwd, '.python-version')) then
            python_path = vim.fn.system('pyenv which python'):gsub("\n", "")
          end
          config.settings = { python = { pythonPath = python_path } }
        end,
      })

      lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
        end,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          javascript = { format = { semicolons = "insert" } },
          typescript = { format = { semicolons = "insert" } },
        },
      })

      -- Setup colorizer.nvim to highlight colors inline
      require("colorizer").setup({
        "*"; -- Highlight all files, or specify filetypes like "css", "html", "lua", "javascript"
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = false,
  },
}

