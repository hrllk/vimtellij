local test_file = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p")
local repo_root = test_file:match("^(.*)/tests/")
package.path = repo_root .. "/lua/?.lua;" .. repo_root .. "/lua/?/init.lua;" .. package.path

local function assert_equal(actual, expected, message)
  if actual ~= expected then
    error((message or "assertion failed") .. (" (expected %s, got %s)"):format(vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_truthy(value, message)
  if not value then
    error(message or "expected a truthy value")
  end
end

local function assert_nil(value, message)
  if value ~= nil then
    error((message or "expected nil") .. (" (got %s)"):format(vim.inspect(value)))
  end
end

local colors = require("config.colors")
assert_equal(colors.none, "NONE", "keeps transparent background token")
assert_equal(colors.dashboard_accent, "#A1A1AA", "uses the existing dashboard accent")

package.preload["milli.runtime"] = function()
  return { load = function() return { frames = { { "" } }, delays = { 1 } } end }
end

local dashboard = require("config.snacks_dashboard")
dashboard.setup({ splash = "test" })

local function rgb(hex)
  return tonumber(hex:sub(2), 16)
end

-- Body text stays neutral against the greyscale splash; the keys and their
-- icons are the only part that takes the palette accent.
local function assert_dashboard_highlights()
  for _, group in ipairs({
    "SnacksDashboardNormal",
    "SnacksDashboardHeader",
    "SnacksDashboardDesc",
    "SnacksDashboardFooter",
    "SnacksDashboardTitle",
    "SnacksDashboardSpecial",
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    assert_equal(hl.fg, rgb(colors.dashboard_accent), group .. " foreground")
    assert_nil(hl.bg, group .. " transparent background")
  end

  local icon = vim.api.nvim_get_hl(0, { name = "SnacksDashboardIcon", link = false })
  assert_equal(icon.fg, rgb(colors.accent), "dashboard icon takes the accent")
  assert_nil(icon.bg, "dashboard icon transparent background")

  local key = vim.api.nvim_get_hl(0, { name = "SnacksDashboardKey", link = false })
  assert_equal(key.fg, rgb(colors.accent), "dashboard key takes the accent")
  assert_nil(key.bg, "dashboard key transparent background")
  assert_equal(key.bold, true, "dashboard key remains bold")
end

assert_dashboard_highlights()

for _, event in ipairs({ "ColorScheme", "VimEnter" }) do
  vim.api.nvim_exec_autocmds(event, {})
  vim.wait(20)
  assert_dashboard_highlights()
end

for _, event in ipairs({ "SnacksDashboardOpened", "SnacksDashboardUpdatePost" }) do
  vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { fg = "#FF0000", bg = "#000000" })
  vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#FF0000", bg = "#000000" })
  vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#FF0000", bg = "#000000", bold = false })
  vim.api.nvim_exec_autocmds("User", { pattern = event })
  vim.wait(20)
  assert_dashboard_highlights()
end

local theme_spec = require("plugins.ui.theme")[1]
local hl = theme_spec.opts.highlights
for _, group in ipairs({
  "SnacksDashboardNormal",
  "SnacksDashboardHeader",
  "SnacksDashboardIcon",
  "SnacksDashboardDesc",
  "SnacksDashboardKey",
  "SnacksDashboardFooter",
  "SnacksDashboardTitle",
  "SnacksDashboardSpecial",
}) do
  assert_nil(hl[group], "theme must not own " .. group)
end
assert_equal(hl.SnacksDashboardTerminal.bg, colors.terminal, "theme keeps terminal override")
assert_equal(hl.Normal.bg, colors.none, "theme keeps transparent Normal")
assert_equal(hl.RenderMarkdownCode.bg, colors.none, "theme keeps transparent Markdown code")

local theme_source = table.concat(vim.fn.readfile(repo_root .. "/lua/plugins/ui/theme.lua"), "\n")
assert_equal(theme_source:find("bg = none", 1, true), nil, "theme has no undefined none reference")

local dashboard_source = table.concat(vim.fn.readfile(repo_root .. "/lua/config/snacks_dashboard.lua"), "\n")
for _, group in ipairs({
  "SnacksDashboardNormal",
  "SnacksDashboardHeader",
  "SnacksDashboardIcon",
  "SnacksDashboardDesc",
  "SnacksDashboardKey",
  "SnacksDashboardFooter",
  "SnacksDashboardTitle",
  "SnacksDashboardSpecial",
}) do
  local definition = 'nvim_set_hl(0, "' .. group .. '"'
  assert_truthy(dashboard_source:find(definition, 1, true), "dashboard owns " .. group)
  for _, source_file in ipairs(vim.fn.globpath(repo_root .. "/lua", "**/*.lua", false, true)) do
    local source = table.concat(vim.fn.readfile(source_file), "\n")
    if source_file ~= repo_root .. "/lua/config/snacks_dashboard.lua" then
      assert_nil(source:find(definition, 1, true), "duplicate dashboard owner: " .. source_file)
    end
  end
end

print("theme_highlight_spec: all assertions passed")
vim.cmd("qa!")
