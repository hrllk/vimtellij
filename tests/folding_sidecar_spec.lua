local test_file = debug.getinfo(1, "S").source:sub(2)
local repo_root = test_file:match("^(.*)/tests/")
package.path = repo_root .. "/lua/?.lua;" .. repo_root .. "/lua/?/init.lua;" .. package.path

local sidecar = require("config.folding_sidecar")

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

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local filename = root .. "/round-trip.md"
local bufnr = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(bufnr, filename)
vim.bo[bufnr].filetype = "markdown"
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
  "# Root",
  "## Section",
  "alpha",
  "omega",
  "## Other",
  "beta",
})

local expected_root = vim.fn.resolve(root)
assert_equal(sidecar.path(bufnr), expected_root .. "/.round-trip.md.folds.json", "uses sidecar convention")
assert_truthy(sidecar.is_markdown(bufnr), "recognizes markdown buffer")
assert_nil(sidecar.read(bufnr), "missing sidecar reads as nil")
assert_truthy(sidecar.capture(bufnr, 2, 4), "captures a non-empty range")
assert_equal(sidecar.capture(bufnr, 7, 7), nil, "out-of-range capture is nil")
assert_equal(sidecar.upsert(bufnr, 2, 4), true, "upsert writes a new entry")

local state = sidecar.read(bufnr)
assert_equal(state.version, 2, "writes version 2")
assert_equal(state.source, "round-trip.md", "writes basename source")
assert_equal(#state.folds, 1, "writes one fold")
assert_equal(state.folds[1].start.text, "## Section", "writes start anchor")

vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { "preamble" })
vim.api.nvim_set_current_buf(bufnr)
vim.wo.foldmethod = "manual"
assert_equal(sidecar.restore(bufnr), true, "restores valid sidecar")
assert_equal(vim.fn.foldclosed(3), 3, "restores shifted fold start")
assert_equal(vim.fn.foldclosedend(3), 5, "restores shifted fold end")

assert_equal(sidecar.remove_for_range(bufnr, 3, 5), true, "removes matching fold")
assert_equal(#sidecar.read(bufnr).folds, 0, "removes fold from sidecar")

vim.fn.writefile({ "{not-json" }, sidecar.path(bufnr))
assert_nil(sidecar.read(bufnr), "malformed sidecar is ignored")

vim.fn.writefile({ vim.json.encode({ version = 1, source = "round-trip.md", folds = {} }) }, sidecar.path(bufnr))
assert_nil(sidecar.read(bufnr), "old sidecar version is ignored")
vim.fn.writefile({ vim.json.encode({ version = 2, source = "other.md", folds = {} }) }, sidecar.path(bufnr))
assert_nil(sidecar.read(bufnr), "sidecar for another source is ignored")

local failed_bufnr = vim.api.nvim_create_buf(true, false)
local missing_directory = root .. "/missing"
vim.api.nvim_buf_set_name(failed_bufnr, missing_directory .. "/failed.md")
local failed_path = sidecar.path(failed_bufnr)
assert_equal(sidecar.write(failed_bufnr, {}), false, "write failure returns false")
assert_equal(vim.fn.filereadable(failed_path .. ".tmp." .. vim.fn.getpid()), 0, "failed write cleans temporary file")

vim.fn.delete(root, "rf")
vim.api.nvim_buf_delete(bufnr, { force = true })
vim.api.nvim_buf_delete(failed_bufnr, { force = true })
print("folding_sidecar_spec: all assertions passed")
vim.cmd("qa!")
