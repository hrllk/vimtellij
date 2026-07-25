local M = {}

function M.setup()
  return vim.tbl_deep_extend(
    "force",
    { image = {}, explorer = {} },
    require("config.snacks.lazygit"),
    require("config.snacks.picker"),
    require("config.snacks.dashboard")
  )
end

return M
