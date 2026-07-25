local function dashboard_keys()
  local splash = require("milli").load({ splash = "ididnot" })

  return {
    { action = ":lua Snacks.dashboard.pick('files')", key = "f", text = { { " ", hl = "SnacksDashboardIcon" }, { "Find File", hl = "SnacksDashboardDesc", width = 50 }, { "f", hl = "SnacksDashboardKey" } } },
    { action = ":lua Snacks.dashboard.pick('oldfiles')", key = "r", text = { { " ", hl = "SnacksDashboardIcon" }, { "Recent Files", hl = "SnacksDashboardDesc", width = 50 }, { "r", hl = "SnacksDashboardKey" } } },
    { action = ":Lazy", key = "L", enabled = package.loaded.lazy ~= nil, text = { { "󰒲 ", hl = "SnacksDashboardIcon" }, { "Lazy", hl = "SnacksDashboardDesc", width = 50 }, { "L", hl = "SnacksDashboardKey" } } },
    { action = ":qa", key = "q", text = { { " ", hl = "SnacksDashboardIcon" }, { "Quit", hl = "SnacksDashboardDesc", width = 50 }, { "q", hl = "SnacksDashboardKey" } } },
  }, splash
end

local keys, splash = dashboard_keys()

return {
  dashboard = {
    enabled = true,
    preset = {
      header = table.concat(splash.frames[1], "\n"),
      keys = keys,
    },
    sections = {
      { section = "header", padding = 1 },
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    },
  },
}
