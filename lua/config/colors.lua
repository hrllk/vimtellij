------------------------------
-- palette
-- single source of truth for every colour the config paints itself with.
-- Change a value here and every consumer follows, including lazygit, which
-- reads the palette-backed highlight groups defined in config/theme.lua.
--
-- accent and border are the two keys that carry the UI's colour. They are
-- the 400 and 700 steps of one Tailwind hue, so swapping the hue is a
-- two-line edit:
--   accent -- window separators, active borders, markdown inline code
--   border -- float borders, picker and explorer borders, inactive borders
------------------------------
return {
  accent = "#FB923C", -- orange-400
  border = "#C2410C", -- orange-700
  dashboard_accent = "#A1A1AA",
  inactive = "#52525B",
  incline_bg = "#363944",
  none = "NONE",
  selection = "#264F78", -- VS Code Dark+ selection colour
  terminal = "#000000",
  terminal_inline = "#0B1220",
}
