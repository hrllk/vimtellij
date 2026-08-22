local test_file = debug.getinfo(1, "S").source:sub(2)
local repo_root = test_file:match("^(.*)/tests/") or vim.fn.getcwd()
package.path = repo_root .. "/lua/?.lua;" .. repo_root .. "/lua/?/init.lua;" .. package.path

local function assert_truthy(value, message)
  if not value then
    error(message or "expected a truthy value")
  end
end

local function assert_equal(actual, expected, message)
  if actual ~= expected then
    error(("%s: expected %s, got %s"):format(message or "values differ", expected, actual))
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
vim.wo.foldenable = true

package.preload["ufo"] = function()
  return {
    setup = function() end,
    peekFoldedLinesUnderCursor = function() end,
  }
end

local sidecar = require("config.folding_sidecar")
local folding_adapter = require("config.folding_adapter")
local plugin_spec = dofile(repo_root .. "/lua/plugins/editor/folding.lua")
plugin_spec[1].config()
vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })

local visual_mapping = vim.fn.maparg("zf", "x", false, true)
local normal_mapping = vim.fn.maparg("zo", "n", false, true)
assert_equal(visual_mapping.buffer, 1, "registers Markdown Visual zf mapping")
assert_truthy(visual_mapping.callback ~= nil, "zf mapping has a callback")
assert_equal(normal_mapping.buffer, 1, "registers Markdown normal zo mapping")
assert_truthy(normal_mapping.callback ~= nil, "zo mapping has a callback")
assert_truthy(vim.b[bufnr].markdown_fold_mappings_installed, "marks mapping installer complete")

vim.fn.setpos("'<", { 0, 2, 1, 0 })
vim.fn.setpos("'>", { 0, 4, 1, 0 })
vim.api.nvim_win_set_cursor(0, { 2, 0 })
vim.cmd("2,4fold")
assert_equal(vim.fn.foldclosed(2), 2, "native fold exists before zf callback")
visual_mapping.callback()
local sidecar_path = root .. "/.adapter.md.folds.json"
assert_equal(vim.fn.filereadable(sidecar_path), 1, "zf callback persists after native fold")

assert_truthy(sidecar.write(bufnr, {
  sidecar.capture(bufnr, 2, 4),
  sidecar.capture(bufnr, 1, 1),
}), "seeds two exact sidecar entries")
local state_with_two_folds = sidecar.read(bufnr)
assert_equal(#state_with_two_folds.folds, 2, "sidecar starts with two entries")

vim.api.nvim_win_set_cursor(0, { 2, 0 })
folding_adapter.open_markdown_fold(bufnr, sidecar, function() end)
local state_after_zo = sidecar.read(bufnr)
assert_equal(#state_after_zo.folds, 1, "zo removes only the opened fold entry")
assert_equal(state_after_zo.folds[1].start.text, "# Root", "zo preserves the unrelated entry")

local unchanged_before_non_closed = vim.fn.readfile(sidecar_path)[1]
vim.api.nvim_win_set_cursor(0, { 1, 0 })
folding_adapter.open_markdown_fold(bufnr, sidecar, function() end)
assert_equal(vim.fn.readfile(sidecar_path)[1], unchanged_before_non_closed, "zo on a non-fold line leaves sidecar unchanged")

assert_truthy(sidecar.upsert(bufnr, 2, 4), "recreates the fold sidecar entry")
vim.cmd("2,4fold")
local unchanged_before_restore = vim.fn.readfile(sidecar_path)[1]
vim.b[bufnr].fold_sidecar_restoring = true
vim.api.nvim_win_set_cursor(0, { 2, 0 })
folding_adapter.open_markdown_fold(bufnr, sidecar, function() end)
vim.b[bufnr].fold_sidecar_restoring = false
assert_equal(vim.fn.readfile(sidecar_path)[1], unchanged_before_restore, "restore guard skips sidecar mutation")

local original_write = sidecar.write
local warning_message
local original_notify = vim.notify
sidecar.write = function()
  return false
end
vim.notify = function(message)
  warning_message = message
end
folding_adapter.open_markdown_fold(bufnr, sidecar, function(ok)
  if ok == false then
    vim.notify("Failed to save the Markdown fold sidecar.", vim.log.levels.WARN)
  end
end)
vim.notify = original_notify
assert_truthy(warning_message and warning_message:match("Failed to save"), "zo warns when sidecar write fails")
assert_equal(vim.fn.readfile(sidecar_path)[1], unchanged_before_restore, "failed sidecar write leaves content unchanged")
sidecar.write = original_write

local other_buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(other_buf, root .. "/plain.txt")
vim.bo[other_buf].filetype = "text"
vim.api.nvim_set_current_buf(other_buf)
vim.api.nvim_exec_autocmds("FileType", { buffer = other_buf })
local other_mapping = vim.fn.maparg("zo", "n", false, true)
assert_truthy(other_mapping.buffer == nil or other_mapping.buffer == 0, "does not install sidecar zo for other filetypes")

vim.fn.delete(root, "rf")
vim.api.nvim_buf_delete(other_buf, { force = true })
vim.api.nvim_buf_delete(bufnr, { force = true })
print("folding_adapter_smoke: all assertions passed")
vim.cmd("qa!")
