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
