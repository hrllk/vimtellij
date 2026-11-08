local colors = require("config.colors")

------------------------------
-- palette-backed highlight groups
-- Named groups that stand in for the config/colors.lua palette. Plugins that
-- can only be pointed at a highlight group by name -- lazygit, which snacks
-- themes by reading groups out of Neovim -- link to these, so the palette
-- stays the one place a colour is changed.
------------------------------

local M = {}

M.groups = {
  UserAccent = { fg = colors.accent },
  UserAccentBold = { fg = colors.accent, bold = true },
  UserBorder = { fg = colors.border },
  UserInactive = { fg = colors.inactive },
  UserDashboardAccent = { fg = colors.dashboard_accent },
  UserSelection = { bg = colors.selection },

  -- theme override (background)
  Visual = { bg = colors.selection },
  VisualNOS = { bg = colors.selection },
}

local palette_group = vim.api.nvim_create_augroup("UserPaletteHighlight", { clear = true })

function M.apply()
  for group, spec in pairs(M.groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

M.apply()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = palette_group,
  callback = M.apply,
})

return M
