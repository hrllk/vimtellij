local M = {}

local function trim(text)
  return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.normalize(text)
  return trim(text):gsub("%s+", " ")
end

function M.is_ignorable(text)
  local value = trim(text or "")
  return value == "" or value:match("^[-*_]%s*[-*_]%s*[-*_][%s%-%*_]*$") ~= nil
end

function M.occurrence_at(document_lines, line_number, text)
  local occurrence = 0
  for index, line in ipairs(document_lines) do
    if not M.is_ignorable(line) and M.normalize(line) == text then
      occurrence = occurrence + 1
      if index == line_number then
        return occurrence
      end
    end
  end
end

function M.find_occurrence(document_lines, text, occurrence)
  local found = 0
  for line_number, line in ipairs(document_lines) do
    if not M.is_ignorable(line) and M.normalize(line) == text then
      found = found + 1
      if found == occurrence then
        return line_number
      end
    end
  end
end

function M.capture(document_lines, start_line, end_line)
  local first_line
  local last_line

  for line_number = start_line, end_line do
    local line = document_lines[line_number]
    if line and not M.is_ignorable(line) then
      first_line = first_line or line_number
      last_line = line_number
    end
  end

  if not first_line or not last_line then
    return nil
  end

  local start_text = M.normalize(document_lines[first_line])
  local end_text = M.normalize(document_lines[last_line])
  return {
    start = {
      text = start_text,
      occurrence = M.occurrence_at(document_lines, first_line, start_text),
    },
    ["end"] = {
      text = end_text,
      occurrence = M.occurrence_at(document_lines, last_line, end_text),
    },
    state = "closed",
  }
end

function M.resolve(document_lines, entry)
  if type(entry) ~= "table" or type(entry.start) ~= "table" or type(entry["end"]) ~= "table" then
    return nil
  end

  local start_line = M.find_occurrence(document_lines, entry.start.text, entry.start.occurrence)
  local end_line = M.find_occurrence(document_lines, entry["end"].text, entry["end"].occurrence)
  if not start_line or not end_line or start_line > end_line then
    return nil
  end

  return { entry = entry, start_line = start_line, end_line = end_line }
end

function M.same_anchor(left, right)
  return type(left) == "table"
    and type(right) == "table"
    and left.text == right.text
    and left.occurrence == right.occurrence
end

function M.same_entry(left, right)
  return type(left) == "table"
    and type(right) == "table"
    and M.same_anchor(left.start, right.start)
    and M.same_anchor(left["end"], right["end"])
end

function M.partially_overlaps(left, right)
  local intersects = left.start_line <= right.end_line and right.start_line <= left.end_line
  local nested = (left.start_line <= right.start_line and right.end_line <= left.end_line)
    or (right.start_line <= left.start_line and left.end_line <= right.end_line)
  return intersects and not nested
end

return M
