------------------------------
-- qol (quality of life) collection plugins
-- explorer, picker, lazygit, git, etc ...
------------------------------
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "amansingh-afk/milli.nvim" },
    init = function()
      vim.g.snacks_animate = false

      local function apply_picker_highlights()
        local none = "NONE"
        vim.api.nvim_set_hl(0, "SnacksNormal", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksWinSeparator", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPicker", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerList", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerTitle", { bg = none })
      end

      apply_picker_highlights()
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = apply_picker_highlights,
      })
    end,
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      {
        "<leader>gg",
        function()
          local root = Snacks.git.get_root() or vim.uv.cwd()
          Snacks.lazygit({ cwd = root })
        end,
        desc = "Lazygit",
      },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    },
    opts = function()
      return require("config.snacks").setup()
    end,
    config = function(_, opts)
      require("snacks").setup(opts)
      require("config.snacks_dashboard").setup({ splash = "ididnot" })
    end,
  },
}
