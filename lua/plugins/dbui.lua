------------------------------
-- database UI
-- browse databases and execute SQL with vim-dadbod-ui
------------------------------
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 40
    end,
    keys = {
      { "<leader>db", "<Cmd>DBUIToggle<CR>", desc = "Database UI" },
      { "<leader>dB", "<Cmd>DBUI<CR>", desc = "Open Database UI" },
    },
  },
}
