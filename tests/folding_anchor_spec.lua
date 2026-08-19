local test_file = debug.getinfo(1, "S").source:sub(2)
local repo_root = test_file:match("^(.*)/tests/")
package.path = repo_root .. "/lua/?.lua;" .. repo_root .. "/lua/?/init.lua;" .. package.path

local anchor = require("config.folding_anchor")

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

local lines = {
  "# Root",
  "## Section",
  "alpha   beta",
  "---",
  "omega",
  "## Section",
  "tail",
}

assert_equal(anchor.normalize("  alpha   beta  "), "alpha beta", "normalizes whitespace")
assert_truthy(anchor.is_ignorable("   "), "blank lines are ignorable")
assert_truthy(anchor.is_ignorable("- * _"), "separator lines are ignorable")
assert_equal(anchor.occurrence_at(lines, 2, "## Section"), 1, "captures first occurrence")
assert_equal(anchor.occurrence_at(lines, 6, "## Section"), 2, "captures duplicate occurrence")
assert_equal(anchor.find_occurrence(lines, "## Section", 2), 6, "resolves duplicate occurrence")
assert_nil(anchor.find_occurrence(lines, "missing", 1), "missing occurrence is unresolved")

local entry = anchor.capture(lines, 2, 5)
assert_equal(entry.start.text, "## Section", "capture uses first non-ignorable line")
assert_equal(entry.start.occurrence, 1, "capture stores start occurrence")
assert_equal(entry["end"].text, "omega", "capture uses last non-ignorable line")
assert_equal(entry.state, "closed", "capture stores closed state")

local changed_lines = { "preamble", "# Root", "## Section", "alpha   beta", "---", "omega", "## Section", "tail" }
local resolved = anchor.resolve(changed_lines, entry)
assert_equal(resolved.start_line, 3, "resolves start after insertion")
assert_equal(resolved.end_line, 6, "resolves end after insertion")
assert_equal(resolved.entry, entry, "preserves original entry")
assert_nil(anchor.resolve(changed_lines, {
  start = { text = "missing", occurrence = 1 },
  ["end"] = { text = "omega", occurrence = 1 },
}), "skips entries with missing anchors")

assert_truthy(anchor.partially_overlaps({ start_line = 2, end_line = 5 }, { start_line = 4, end_line = 7 }), "detects partial overlap")
assert_equal(anchor.partially_overlaps({ start_line = 2, end_line = 7 }, { start_line = 4, end_line = 5 }), false, "allows nested ranges")
assert_equal(anchor.partially_overlaps({ start_line = 2, end_line = 5 }, { start_line = 6, end_line = 7 }), false, "rejects disjoint ranges")

print("folding_anchor_spec: all assertions passed")
vim.cmd("qa!")
