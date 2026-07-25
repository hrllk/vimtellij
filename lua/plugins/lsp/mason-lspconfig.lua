return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      local ensure_installed = { "lua_ls", "gopls" }
      if vim.fn.executable("node") == 1 and vim.fn.executable("npm") == 1 then
        table.insert(ensure_installed, "ts_ls")
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })
    end,
  },
}
