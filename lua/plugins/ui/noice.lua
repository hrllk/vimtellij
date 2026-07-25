------------------------------
-- message UI
-- improve command-line messages, notifications, and LSP popups
------------------------------
return {
  {
    "folke/noice.nvim",
    lazy = false,
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = { event = "notify", find = "No information available" },
        opts = { skip = true },
      })
      opts.presets = opts.presets or {}
      opts.presets.lsp_doc_border = true
    end,
  },
}
