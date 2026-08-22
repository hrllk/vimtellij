local M = {}

function M.open_markdown_fold(bufnr, sidecar, warn_write_failure)
  local current_line = vim.fn.line(".")
  local fold_start = vim.fn.foldclosed(current_line)
  if fold_start == -1 then
    pcall(vim.cmd, "normal! zo")
    return
  end

  local fold_end = vim.fn.foldclosedend(current_line)
  vim.cmd(("%d,%dfoldopen"):format(fold_start, fold_end))
  if not vim.b[bufnr].fold_sidecar_restoring then
    warn_write_failure(sidecar.remove_for_range(bufnr, fold_start, fold_end))
  end
end

return M
