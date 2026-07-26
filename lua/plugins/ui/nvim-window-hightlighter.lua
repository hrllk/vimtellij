local colors = require("config.colors")

------------------------------
-- window separator highlight
-- highlight the boundaries between Neovim windows
------------------------------
return {
  {
    "nvim-zh/colorful-winsep.nvim",
    opts = {
      highlight = colors.accent,
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("colorful-winsep").setup(opts)

      local focused = true
      local group = vim.api.nvim_create_augroup("ColorfulWinSepFocus", { clear = true })

      local function apply_highlight()
        vim.api.nvim_set_hl(0, "ColorfulWinSep", {
          fg = focused and colors.accent or colors.inactive,
          bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,
        })
      end

      vim.api.nvim_create_autocmd("FocusLost", {
        group = group,
        callback = function()
          focused = false
          apply_highlight()
        end,
      })

      vim.api.nvim_create_autocmd("FocusGained", {
        group = group,
        callback = function()
          focused = true
          apply_highlight()
        end,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = apply_highlight,
      })

      apply_highlight()
    end,
  },
}
