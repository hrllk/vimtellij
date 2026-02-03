return {


  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      -- ensure that we have lua language server, typescript launguage server, java language server, and java test language server are installed
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls" },        -- mason registry needs
      })
    end
  },

  -- LspInfo, LspLog
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "mfussenegger/nvim-jdtls" },
    config = function()

      local lspconfig = require("lspconfig")

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- setup the lua language server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      -- setup the typescript language server
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      vim.keymap.set("n", "<leader>O", ":lua vim.lsp.buf.code_action()<CR>")
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
      vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
      -- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
      vim.keymap.set("n", "gr", function()
        Snacks.picker.lsp_references({
          include_declaration = true,
          include_current = true,
          layout = { preset = "select" },
        })
      end, { desc = "LSP References (Snacks Ivy)" })
      vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
      vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>")

    end
  },

  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
  }
}
