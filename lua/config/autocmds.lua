-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- auto format false
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "*" },
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
    vim.api.nvim_set_hl(0, "StrikeoutColor", { bg = 016, fg = "Grey" })
    vim.api.nvim_set_hl(0, "StrikeoutMatch", { link = "StrikeoutColor" })
  end,
})


-- visual color
-- vim.api.nvim_command("hi Visual guifg=#000000 guibg=#33FF00 gui=none")





------------------------------
-- calling automatically neovim starts
------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command("ShowkeysToggle") -- show key toggle
  end,
})

-- vim.fn.system("rm -rf ~/.cache/nvim/jdtls/")
vim.api.nvim_command("hi Visual guifg=#000000 guibg=#666699 gui=none")


-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "java",
--   callback = function()
--     -- Optional: Add a notification to see when it triggers
--     -- vim.notify("Java file opened, attempting to set up JDTLS", vim.log.levels.INFO)
--     -- Call the setup_jdtls function
--     local ts_configs = require("nvim-treesitter.configs")
--     if ts_configs.has_language("java") then
--       ts_configs.attach(0) -- 0은 현재 버퍼를 의미합니다.
--     end
--   end,
-- })

-- vim.cmd [[
--     augroup jdtls_lsp
--         autocmd!
--         autocmd FileType java lua require'config.jdtls'.setup_jdtls()
--     augroup end
-- ]]

