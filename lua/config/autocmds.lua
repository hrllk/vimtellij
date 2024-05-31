-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- auto format false
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "java, tsx" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*" },
  command = "silent! wall",
  nested = true,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("StrikeoutMatch", { clear = true }),
  pattern = { "*.md" },
  callback = function()
    vim.fn.matchadd("StrikeoutMatch", "\\~\\~.*\\~\\~")
    -- vim.api.nvim_set_hl(0, "StrikeoutColor", { bg = 016, fg = "Black" })
    vim.api.nvim_set_hl(0, "StrikeoutColor", { fg = "Grey" })
    vim.api.nvim_set_hl(0, "StrikeoutMatch", { link = "StrikeoutColor" })
  end,
})



vim.api.nvim_command("hi Visual guifg=#000000 guibg=#33FF00 gui=none")
