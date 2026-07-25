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

      vim.keymap.set("n", "<leader>O", ":lua vim.lsp.buf.code_action()<CR>")
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
      vim.keymap.set("n", "K", function()
        local ok, ufo = pcall(require, "ufo")
        if ok then
          local winid = ufo.peekFoldedLinesUnderCursor()
          if winid then
            return
          end
        end

        vim.lsp.buf.hover()
      end, { desc = "Hover / fold preview" })
      vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
      vim.keymap.set("n", "gr", function()
        Snacks.picker.lsp_references({
          include_declaration = true,
          include_current = true,
          layout = { preset = "select" },
        })
      end, { desc = "LSP References (Snacks Ivy)" })
      vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
      vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>")
    end,
  },
}
