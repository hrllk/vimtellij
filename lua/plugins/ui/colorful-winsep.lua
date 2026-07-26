------------------------------
-- window separator highlight
-- highlight the boundaries between Neovim windows
------------------------------
return {
  {
    "nvim-zh/colorful-winsep.nvim",
    opts = {
      highlight = "#2DD4BF",
    },
    event = { "WinLeave" },
  },
}
