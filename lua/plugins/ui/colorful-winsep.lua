------------------------------
-- window separators
-- highlight the boundaries between Neovim windows
------------------------------
return {
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
}
