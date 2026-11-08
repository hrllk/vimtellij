------------------------------
-- lazygit options
-- Snacks themes lazygit by reading highlight groups out of Neovim, so point
-- it at the palette-backed groups from config/theme.lua. Keys left out here
-- keep the Snacks defaults (cherry picked commits, options text, unstaged
-- changes), which follow the colorscheme.
------------------------------
return {
  lazygit = {
    configure = true,
    theme = {
      activeBorderColor = { fg = "UserAccent", bold = true },
      searchingActiveBorderColor = { fg = "UserAccent", bold = true },
      inactiveBorderColor = { fg = "UserBorder" },
      selectedLineBgColor = { bg = "UserSelection" },
    },
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
}
