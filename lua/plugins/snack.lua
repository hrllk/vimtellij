return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {},
    keys = {
      {
        "<leader>rn",
        function()
          require("snacks").rename.rename_file()
        end,
        desc = "Fast Rename Current File",
      },
      {
        "<leader>th",
        function()
          require("snacks").picker.colorschemes({ layout = "ivy" })
        end,
        desc = "Pick Color Schemes",
      },
      {
        "<leader>gbr",
        function()
          require("snacks").picker.git_branches({ layout = "select" })
        end,
        desc = "Pick and Switch Git Branch",
      },
    },
  },
  -- {
  --   "folke/todo-comments.nvim",
  --   event = { "BufReadPre", "BufNewFile"},
  --   keys = {
  --     { "<leader>pt", function() require("snacks").picker.colorschemes({ layout = "ivy" }) end, desc = "Pick Color Schemes"},
  --   }
  -- }
}
