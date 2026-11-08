------------------------------
-- palette
-- single source of truth for every colour the config paints itself with.
-- Change a value here and every consumer follows, including lazygit, which
-- reads the palette-backed highlight groups defined in config/theme.lua.
------------------------------
return {
  accent = "#2DD4BF",
  border = "#0F766E",
  dashboard_accent = "#A1A1AA",
  inactive = "#52525B",
  incline_bg = "#363944",
  none = "NONE",
  selection = "#264F78", -- VS Code Dark+ selection colour
  terminal = "#000000",
  terminal_inline = "#0B1220",
}
