local M = {}

local VERSION = 2

local function debug(message)
  vim.notify("Markdown fold sidecar: " .. message, vim.log.levels.DEBUG)
end

local function basename(path)
  return vim.fn.fnamemodify(path, ":t")
end

local function normalize(text)
  return vim.trim(text):gsub("%s+", " ")
end

local function is_ignorable(text)
  local value = vim.trim(text)
  return value == "" or value:match("^[-*_]%s*[-*_]%s*[-*_][%s%-%*_]*$") ~= nil
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

local function same_anchor(left, right)
  return type(left) == "table"
    and type(right) == "table"
    and left.text == right.text
    and left.occurrence == right.occurrence
end

local function same_entry(left, right)
  return type(left) == "table"
    and type(right) == "table"
    and same_anchor(left.start, right.start)
    and same_anchor(left["end"], right["end"])
end

local function lines(bufnr)
  return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end

local function occurrence_at(document_lines, line_number, text)
  local occurrence = 0
  for index, line in ipairs(document_lines) do
    if not is_ignorable(line) and normalize(line) == text then
      occurrence = occurrence + 1
      if index == line_number then
        return occurrence
      end
    end
  end
end

local function find_occurrence(document_lines, text, occurrence)
  local found = 0
  for line_number, line in ipairs(document_lines) do
    if not is_ignorable(line) and normalize(line) == text then
      found = found + 1
      if found == occurrence then
        return line_number
      end
    end
  end
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
  local ok = vim.fn.writefile({ encoded }, temporary) == 0 and vim.fn.rename(temporary, path) == 0
  if not ok then
    pcall(vim.fn.delete, temporary)
  end

  return ok
end

function M.capture(bufnr, start_line, end_line)
  local document_lines = lines(bufnr)
  local first_line
  local last_line

  for line_number = start_line, end_line do
    if not is_ignorable(document_lines[line_number]) then
      first_line = first_line or line_number
      last_line = line_number
    end
  end

  if not first_line or not last_line then
    return nil
  end

  local start_text = normalize(document_lines[first_line])
  local end_text = normalize(document_lines[last_line])
  return {
    start = {
      text = start_text,
      occurrence = occurrence_at(document_lines, first_line, start_text),
    },
    ["end"] = {
      text = end_text,
      occurrence = occurrence_at(document_lines, last_line, end_text),
    },
    state = "closed",
  }
end

local function resolve_entry(document_lines, entry)
  if type(entry) ~= "table" or type(entry.start) ~= "table" or type(entry["end"]) ~= "table" then
    return nil
  end

  local start_line = find_occurrence(document_lines, entry.start.text, entry.start.occurrence)
  local end_line = find_occurrence(document_lines, entry["end"].text, entry["end"].occurrence)
  if not start_line or not end_line or start_line > end_line then
    return nil
  end

  return { entry = entry, start_line = start_line, end_line = end_line }
end

local function partially_overlaps(left, right)
  local intersects = left.start_line <= right.end_line and right.start_line <= left.end_line
  local nested = (left.start_line <= right.start_line and right.end_line <= left.end_line)
    or (right.start_line <= left.start_line and left.end_line <= right.end_line)
  return intersects and not nested
end

function M.upsert(bufnr, start_line, end_line)
  local entry = M.capture(bufnr, start_line, end_line)
  if not entry then
    return false
  end

  local state = M.read(bufnr) or new_state(bufnr)
  local document_lines = lines(bufnr)
  local resolved_new = resolve_entry(document_lines, entry)
  if not resolved_new then
    return nil
  end

  local next_folds = {}
  for _, existing in ipairs(state.folds) do
    if not same_entry(existing, entry) then
      local resolved_existing = resolve_entry(document_lines, existing)
      if resolved_existing and partially_overlaps(resolved_new, resolved_existing) then
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
    if not same_entry(entry, target) then
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
    local item = resolve_entry(document_lines, entry)
    if item then
      local conflicts = false
      for _, existing in ipairs(resolved) do
        if partially_overlaps(item, existing) then
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
