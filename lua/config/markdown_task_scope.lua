------------------------------
-- Markdown task scope highlight
-- render-markdown's checkbox `scope_highlight` only covers the item's own
-- paragraph (see Node:scope), so a task that was split into sub-items keeps
-- every child fully lit after the task itself is dropped. This wraps the
-- builtin handlers to dim the entire list_item subtree instead.
--
-- Icons are virtual text, and a range highlight cannot reach them no matter
-- its priority. Rather than reproducing each icon here, the builtin handlers
-- are run directly and their marks are rewritten, which covers checkboxes,
-- bullets, link icons and anything else they draw.
------------------------------
local M = {}

-- Raw checkbox marker -> highlight for the whole item subtree. Only markers
-- outside the markdown grammar land here: '[ ]' and '[x]' become
-- task_list_marker nodes and never reach the inline text.
local SCOPES = {
  ["[~]"] = "Comment",
}

-- Above tree-sitter's own highlights (100) so link and emphasis colors inside
-- a dropped task do not bleed through.
local PRIORITY = 200

-- Internal plugin modules. Wrapping means `extends` stays off and we invoke
-- these ourselves, so a rename upstream shows up as a missing module here.
local BUILTIN = {
  markdown = "render-markdown.handler.markdown",
  markdown_inline = "render-markdown.handler.markdown_inline",
}

local function child_of_type(node, target)
  for child in node:iter_children() do
    if child:type() == target then
      return child
    end
  end
  return nil
end

-- The marker of a custom checkbox survives in the item's inline text, e.g.
-- '[~] dropped task'. Returns nil for grammar checkboxes and plain items.
local function marker_of(item, buf)
  local paragraph = child_of_type(item, "paragraph")
  local inline = paragraph and child_of_type(paragraph, "inline")
  if not inline then
    return nil
  end
  local text = vim.treesitter.get_node_text(inline, buf)
  return text and text:match("^(%[.%])%s")
end

local function line_at(buf, row)
  return vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
end

-- tree-sitter closes a list_item wherever the next block starts, so the end
-- lands on a following sibling's indent or on a trailing blank line. Walk it
-- back to the last row the item actually owns text on.
local function range_of(item, buf)
  local start_row, start_col = item:start()
  local end_row, end_col = item:end_()

  while end_row > start_row do
    local line = line_at(buf, end_row)
    local indent = #(line:match("^%s*") or "")
    if line:find("%S") and end_col > indent then
      break
    end
    end_row = end_row - 1
    end_col = #line_at(buf, end_row)
  end

  return start_row, start_col, end_row, end_col
end

-- markdown_inline runs before markdown, so the ranges cannot be handed down
-- from one pass to the next. They are recomputed per buffer revision instead.
local cache = {}

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = vim.api.nvim_create_augroup("MarkdownTaskScope", { clear = true }),
  callback = function(args)
    cache[args.buf] = nil
  end,
})

local function dropped_ranges(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local entry = cache[buf]
  if entry and entry.tick == tick then
    return entry.ranges
  end

  local ranges = {}
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if ok and parser then
    local parsed, query = pcall(vim.treesitter.query.parse, "markdown", "(list_item) @item")
    if parsed then
      for _, tree in ipairs(parser:trees()) do
        for _, item in query:iter_captures(tree:root(), buf) do
          local highlight = SCOPES[marker_of(item, buf)]
          if highlight then
            local start_row, start_col, end_row, end_col = range_of(item, buf)
            ranges[#ranges + 1] = {
              start_row = start_row,
              start_col = start_col,
              end_row = end_row,
              end_col = end_col,
              highlight = highlight,
            }
          end
        end
      end
    end
  end

  cache[buf] = { tick = tick, ranges = ranges }
  return ranges
end

local function highlight_at(ranges, row)
  for _, range in ipairs(ranges) do
    if row >= range.start_row and row <= range.end_row then
      return range.highlight
    end
  end
  return nil
end

-- Repaint the icons the builtin handlers drew on a dropped row. Only virtual
-- text is touched; hl_group marks carry backgrounds we would rather keep.
local function dim(mark, highlight)
  local lines = { mark.opts.virt_text }
  for _, line in ipairs(mark.opts.virt_lines or {}) do
    lines[#lines + 1] = line
  end
  for _, line in ipairs(lines) do
    for _, text in ipairs(line) do
      if text[2] then
        text[2] = highlight
      end
    end
  end
end

---@param language string
---@param ctx render.md.handler.Context
---@return render.md.Mark[]
function M.parse(language, ctx)
  local ok, builtin = pcall(require, BUILTIN[language])
  local marks = ok and builtin.parse(ctx) or {}
  local ranges = dropped_ranges(ctx.buf)

  for _, mark in ipairs(marks) do
    local highlight = highlight_at(ranges, mark.start_row)
    if highlight then
      dim(mark, highlight)
    end
  end

  -- The text itself only needs covering once, on the pass that owns the item.
  if language == "markdown" then
    for _, range in ipairs(ranges) do
      marks[#marks + 1] = {
        conceal = false,
        start_row = range.start_row,
        start_col = range.start_col,
        opts = {
          end_row = range.end_row,
          end_col = range.end_col,
          hl_group = range.highlight,
          priority = PRIORITY,
        },
      }
    end
  end

  return marks
end

---@return table<string, render.md.Handler>
function M.handlers()
  local handlers = {}
  for language in pairs(BUILTIN) do
    handlers[language] = {
      parse = function(ctx)
        return M.parse(language, ctx)
      end,
    }
  end
  return handlers
end

return M
