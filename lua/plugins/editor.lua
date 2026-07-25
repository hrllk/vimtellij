return {
  -- -------------------------------------------------
  -- snack nvim related with editor
  -- picker, explorer, image
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
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
        callback = function()
          apply_picker_highlights()
        end,
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
    },
  },

  -- Comment and Mini Files configurations are intentionally disabled.
}
