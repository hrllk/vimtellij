local M = {}
local anchor = require("config.folding_anchor")

local VERSION = 2

local function debug(message)
  vim.notify("Markdown fold sidecar: " .. message, vim.log.levels.DEBUG)
end

local function basename(path)
  return vim.fn.fnamemodify(path, ":t")
end

local function source(bufnr)
  return basename(vim.api.nvim_buf_get_name(bufnr))
end

local function new_state(bufnr, folds)
  return {
    version = VERSION,
    source = source(bufnr),
    folds = folds or {},
  }
end

local function valid_state(state, expected_source)
  return type(state) == "table"
    and state.version == VERSION
    and state.source == expected_source
    and type(state.folds) == "table"
end

local function lines(bufnr)
  return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end

function M.path(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return nil
  end

  return vim.fs.dirname(filename) .. "/." .. basename(filename) .. ".folds.json"
end

function M.is_markdown(bufnr)
  return vim.bo[bufnr].buftype == "" and vim.bo[bufnr].filetype == "markdown" and M.path(bufnr) ~= nil
end

function M.read(bufnr)
  local path = M.path(bufnr)
  if not path or vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local ok, decoded = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok or not valid_state(decoded, source(bufnr)) then
    debug("invalid sidecar format; skipping restore")
    return nil
  end

  return decoded
end

function M.write(bufnr, folds)
  local path = M.path(bufnr)
  if not path then
    return false
  end

  local encoded = vim.json.encode(new_state(bufnr, folds))
  local temporary = ("%s.tmp.%d"):format(path, vim.fn.getpid())
  local wrote, write_result = pcall(vim.fn.writefile, { encoded }, temporary)
  local ok = wrote and write_result == 0
  if ok then
    local renamed, rename_result = pcall(vim.fn.rename, temporary, path)
    ok = renamed and rename_result == 0
  end
  if not ok then
    pcall(vim.fn.delete, temporary)
  end

  return ok
end

function M.capture(bufnr, start_line, end_line)
  return anchor.capture(lines(bufnr), start_line, end_line)
end

function M.upsert(bufnr, start_line, end_line)
  local entry = M.capture(bufnr, start_line, end_line)
  if not entry then
    return false
  end

  local state = M.read(bufnr) or new_state(bufnr)
  local document_lines = lines(bufnr)
  local resolved_new = anchor.resolve(document_lines, entry)
  if not resolved_new then
    return nil
  end

  local next_folds = {}
  for _, existing in ipairs(state.folds) do
    if not anchor.same_entry(existing, entry) then
      local resolved_existing = anchor.resolve(document_lines, existing)
      if resolved_existing and anchor.partially_overlaps(resolved_new, resolved_existing) then
        return nil
      end
      next_folds[#next_folds + 1] = existing
    end
  end
  next_folds[#next_folds + 1] = entry

  return M.write(bufnr, next_folds)
end

function M.remove_for_range(bufnr, start_line, end_line)
  local state = M.read(bufnr)
  if not state then
    return true
  end

  local target = M.capture(bufnr, start_line, end_line)
  if not target then
    return true
  end

  local next_folds = {}
  for _, entry in ipairs(state.folds) do
    if not anchor.same_entry(entry, target) then
      next_folds[#next_folds + 1] = entry
    end
  end

  if #next_folds == #state.folds then
    return true
  end
  return M.write(bufnr, next_folds)
end

function M.restore(bufnr)
  local state = M.read(bufnr)
  if not state then
    return false
  end

  local document_lines = lines(bufnr)
  local resolved = {}
  for _, entry in ipairs(state.folds) do
    local item = anchor.resolve(document_lines, entry)
    if item then
      local conflicts = false
      for _, existing in ipairs(resolved) do
        if anchor.partially_overlaps(item, existing) then
          conflicts = true
          break
        end
      end
      if not conflicts then
        resolved[#resolved + 1] = item
      else
        debug("skipping partially overlapping fold")
      end
    else
      debug("skipping fold because its anchors could not be found")
    end
  end

  table.sort(resolved, function(left, right)
    return left.start_line > right.start_line
  end)
  for _, item in ipairs(resolved) do
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd(("%d,%dfold"):format(item.start_line, item.end_line))
    end)
  end

  return true
end

return M
