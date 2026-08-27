------------------------------
-- language servers
-- configure and enable language servers and LSP keymaps
------------------------------
return {
  {
    "neovim/nvim-lspconfig",
    -- mason.nvim prepends its bin directory to PATH on setup. Without this
    -- dependency the load order is undefined, so the executable() probe below
    -- can run before PATH is patched and silently skip the server.
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
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
    end,
  },
}
