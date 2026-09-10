------------------------------
-- keymap hints
-- show available keymaps and their descriptions
------------------------------
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>t", group = "test" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
