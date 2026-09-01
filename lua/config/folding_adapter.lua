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
  -- Skip the sidecar write while a restore is in flight. sidecar.restore()
  -- opens and re-folds ranges itself, so without this guard a fold opened
  -- during restoration deletes its own sidecar entry and the file quietly loses
  -- its folds over a few sessions. The flag is set around the restore call in
  -- plugins/editor/folding.lua.
  if not vim.b[bufnr].fold_sidecar_restoring then
    warn_write_failure(sidecar.remove_for_range(bufnr, fold_start, fold_end))
  end
end

return M
