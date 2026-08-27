------------------------------
-- LSP package bridge
-- install and connect Mason packages to LSP configuration
------------------------------
return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      local ensure_installed = {
        "gopls",
        "lua_ls",
        "marksman",
        "ts_ls",
      }

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })
    end,
  },
}
