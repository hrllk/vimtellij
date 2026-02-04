-- json 자동 포맷
-- 전역 함수로 등록 (formatexpr에서 호출)
function _G.fmt_json()
  local indent = vim.bo.expandtab and (' '):rep(vim.o.shiftwidth) or '\t'
  local start = vim.v.lnum - 1
  local finish = start + vim.v.count
  local lines = vim.api.nvim_buf_get_lines(0, start, finish, true)

  local ok, obj = pcall(vim.json.decode, table.concat(lines, '\n'))
  if not ok then
    return 0 -- JSON 파싱 실패하면 포맷 안 함
  end

  local stringified = vim.json.encode(obj, { indent = indent, sort_keys = false })
  lines = vim.split(stringified, '\n')
  vim.api.nvim_buf_set_lines(0, start, finish, true, lines)

  return 0
end

-- json 파일타입에서 gq가 위 함수를 쓰도록 연결
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.bo.formatexpr = "v:lua.fmt_json()"
  end,
})
