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
        "clangd", -- C
        "lua_ls", -- Lua
        "html", -- HTML
        "pyright",
        "cssls", -- CSS
        "ts_ls", -- JavaScript & TypeScript 
      },
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- Function to set key mappings when LSP attaches to a buffer
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
        vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
        vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<CR>")
      end

      -- LSP server configurations with on_attach
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- JavaScript & TypeScript 
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          javascript = {
            format = {
              semicolons = "insert",
            },
          },
          typescript = {
            format = {
              semicolons = "insert",
            },
          },
        },
      })

    end,
  },
}

