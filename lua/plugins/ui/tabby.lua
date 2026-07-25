------------------------------
-- tabline
-- display and navigate Neovim tabs
------------------------------
return {
  {
    "nanozuki/tabby.nvim",
    ---@type TabbyConfig
    opts = {
      -- Keep tab labels on the left and hide active window/file labels.
      preset = "tab_only",
    },
  },
}
