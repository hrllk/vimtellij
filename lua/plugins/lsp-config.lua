return {


  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      -- Auto-install only the servers that are available in this environment.
      local ensure_installed = { "lua_ls", "gopls" }
      if vim.fn.executable("node") == 1 and vim.fn.executable("npm") == 1 then
        table.insert(ensure_installed, "ts_ls")
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })
    end
  },

  -- LspInfo, LspLog
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "mfussenegger/nvim-jdtls" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- setup the lua language server
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      -- setup the Go language server
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
    ft = "java",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
  }
}
