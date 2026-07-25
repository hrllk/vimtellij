------------------------------
-- language servers
-- configure and enable language servers and LSP keymaps
------------------------------
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              nilness = true,
              shadow = true,
            },
          },
        },
      })

      local servers = { "lua_ls", "gopls" }
      if vim.fn.executable("typescript-language-server") == 1 then
        vim.lsp.config("ts_ls", {
          capabilities = capabilities,
        })
        table.insert(servers, "ts_ls")
      end

      vim.lsp.enable(servers)
      require("config.lsp.keymaps").setup()
    end,
  },
}
