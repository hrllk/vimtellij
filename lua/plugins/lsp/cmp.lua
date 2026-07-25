return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lsp_kind = cmp.lsp.CompletionItemKind

      pcall(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        completion = {
          keyword_length = 2,
          completeopt = "menu,menuone,noselect",
        },
        performance = {
          debounce = 80,
          throttle = 30,
          fetching_timeout = 200,
          max_view_entries = 40,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      cmp.setup.filetype("java", {
        completion = {
          keyword_length = 3,
          completeopt = "menu,menuone,noselect",
        },
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            keyword_length = 3,
            max_item_count = 30,
            entry_filter = function(entry)
              return entry:get_kind() ~= lsp_kind.Text
            end,
          },
          { name = "luasnip", max_item_count = 10 },
          { name = "buffer", keyword_length = 4, max_item_count = 8 },
          { name = "path", max_item_count = 8 },
        }),
      })
    end,
  },
}
