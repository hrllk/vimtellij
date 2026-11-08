local colors = require("config.colors")

------------------------------
-- palette-backed highlight groups
-- Named groups that stand in for the config/colors.lua palette. Plugins that
-- can only be pointed at a highlight group by name -- lazygit, which snacks
-- themes by reading groups out of Neovim -- link to these, so the palette
-- stays the one place a colour is changed.
--
-- M.keep is the shared way to hold a set of highlights against a colorscheme
-- load. Every caller used to hand-roll the same apply-then-reapply pair, and
-- half of them forgot the augroup, so re-sourcing stacked duplicates.
------------------------------

local M = {}

---Apply highlights now and again whenever a colorscheme loads.
---@param groups table|function group->spec map, or a function that applies them
---@param name string augroup name, unique per caller
---@return function apply the applier, for callers that repaint on other events
function M.keep(groups, name)
  local apply = type(groups) == "function" and groups or function()
    for group, spec in pairs(groups) do
      vim.api.nvim_set_hl(0, group, spec)
    end
  end

  apply()

  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup(name, { clear = true }),
    callback = apply,
  })

  return apply
end

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

M.apply = M.keep(M.groups, "UserPaletteHighlight")

return M
