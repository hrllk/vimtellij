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
    event = { "WinLeave" },
  },
}
