------------------------------
-- harpoon
-- quickly mark and switch between frequently used files
------------------------------
return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", {
        desc = "Harpoon Mark File",
      })
      vim.keymap.set("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", {
        desc = "Harpoon Toggle Menu",
      })
    end,
  },
}
