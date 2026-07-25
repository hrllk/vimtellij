return {
  {
    "hrllk/file-line-range-history",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>gflh",
        ":LineHistory<CR>",
        mode = "x",
        desc = "Git line range history",
      },
    },
    opts = {
      keymap = false,
      window = {
        width = 0.9,
        height = 0.85,
        border = "rounded",
      },
      treesitter = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("line-history").setup(opts)
    end,
  },
}
