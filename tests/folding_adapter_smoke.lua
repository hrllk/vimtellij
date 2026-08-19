local test_file = debug.getinfo(1, "S").source:sub(2)
local repo_root = test_file:match("^(.*)/tests/")
package.path = repo_root .. "/lua/?.lua;" .. repo_root .. "/lua/?/init.lua;" .. package.path

local function assert_truthy(value, message)
  if not value then
    error(message or "expected a truthy value")
  end
end

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local bufnr = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(bufnr, root .. "/adapter.md")
vim.bo[bufnr].filetype = "markdown"
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
  "# Root",
  "## Section",
  "alpha",
  "omega",
})
vim.api.nvim_set_current_buf(bufnr)
vim.wo.foldmethod = "manual"

package.preload["ufo"] = function()
  return {
    setup = function() end,
    peekFoldedLinesUnderCursor = function() end,
  }
end

local captured_on_key
local original_on_key = vim.on_key
local original_schedule = vim.schedule
vim.on_key = function(callback)
  captured_on_key = callback
end
vim.schedule = function(callback)
  callback()
end

local plugin_spec = dofile(repo_root .. "/lua/plugins/editor/folding.lua")
plugin_spec[1].config()
vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })

local mapping = vim.fn.maparg("zf", "x", false, true)
assert_truthy(mapping.buffer == 1, "registers Markdown Visual zf mapping")
assert_truthy(mapping.callback ~= nil, "zf mapping has a callback")
assert_truthy(type(captured_on_key) == "function", "registers on_key observer")

vim.fn.setpos("'<", { 0, 2, 1, 0 })
vim.fn.setpos("'>", { 0, 4, 1, 0 })
vim.fn.setpos(".", { 0, 2, 1, 0 })
vim.wo.foldenable = true
vim.cmd("2,4fold")
assert_truthy(vim.fn.foldclosed(2) == 2, "native fold exists before persistence callback")
mapping.callback()
assert_truthy(vim.fn.filereadable(root .. "/.adapter.md.folds.json") == 1, "zf callback persists after native fold")

captured_on_key("z")
vim.cmd("2,4foldopen")
captured_on_key("o")
-- The adapter schedules sidecar removal; range removal is covered by the integration test.

vim.on_key = original_on_key
vim.schedule = original_schedule
vim.fn.delete(root, "rf")
vim.api.nvim_buf_delete(bufnr, { force = true })
print("folding_adapter_smoke: all assertions passed")
vim.cmd("qa!")
