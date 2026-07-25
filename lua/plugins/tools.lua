return {
  -- -------------------------------------------------
  -- LazyGit
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        -- keep nvim-remote integration so lazygit `e` opens files normally in nvim
        configure = true,
        win = {
          style = "lazygit",
          wo = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
            cursorline = false,
            foldcolumn = "0",
          },
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          local root = Snacks.git.get_root() or vim.uv.cwd()
          Snacks.lazygit({ cwd = root })
        end,
        desc = "Lazygit",
      },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end,      desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end,   desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end,    desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end,     desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    }
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function (_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    }
  }
}
