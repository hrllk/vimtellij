-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- auto format false
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "java" },
  callback = function()
    vim.b.autoformat = false
  end,
})
-- auto save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*" },
  command = "silent! wall",
  nested = true,
})
