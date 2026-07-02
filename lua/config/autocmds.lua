------------------------------
-- auto format turn off
------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    vim.b.autoformat = false
  end,
})

------------------------------
-- visual mode style
------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Visual", { bg = "#264F78" })
    vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#264F78" })
  end,
})

------------------------------
-- auto save
------------------------------
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
  callback = function()
    -- Only auto save if the buffer is modified, has a file name, and is a normal file buffer
    if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= "" and vim.bo.buftype == "" and vim.bo.buflisted then
      vim.cmd("silent w")
    end
  end,
})

