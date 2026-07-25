------------------------------
-- auto save
------------------------------
local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

local function autosave(event)
  local bufnr = event.buf

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local buffer = vim.bo[bufnr]
  if buffer.buftype ~= ""
    or not buffer.buflisted
    or not buffer.modified
    or not buffer.modifiable
    or buffer.readonly
    or vim.api.nvim_buf_get_name(bufnr) == ""
  then
    return
  end

  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd("silent update")
  end)

  if not ok then
    vim.notify_once("AutoSave failed: " .. err, vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  group = autosave_group,
  callback = autosave,
})
