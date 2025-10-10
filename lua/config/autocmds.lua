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



-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = vim.api.nvim_create_augroup("StrikeoutMatch", { clear = true }),
--   pattern = { "*.md" },
--   callback = function()
--     vim.fn.matchadd("StrikeoutMatch", "\\~\\~.*\\~\\~")
--     vim.api.nvim_set_hl(0, "StrikeoutColor", { sp = "Grey", underline = false, strikethrough = true })
--     vim.api.nvim_set_hl(0, "StrikeoutMatch", { link = "StrikeoutColor" })
--   end,
-- })

-- vim.api.nvim_set_hl(0, "Strike", { strikethrough = true })
-- vim.api.nvim_set_hl(0, "@text.strike.markdown", { strikethrough = true })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     -- vim.api.nvim_set_hl(0, "Strike", { strikethrough = true, fg = "Grey" }) -- add color for visibility
--     vim.api.nvim_set_hl(0, "Strike", {
--       strikethrough = true,
--       fg = "Grey",
--       -- term = "strikethrough",
--       -- cterm = "strikethrough",
--       -- gui = "strikethrough",
--     })
--     vim.fn.matchadd("Strike", "\\~\\~\\zs.*\\ze\\~\\~")
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = "markdown",
--   callback = function()
--     -- Ensure highlight survives colorscheme reloads
--     vim.api.nvim_create_autocmd("ColorScheme", {
--       pattern = "*",
--       callback = function()
--         vim.api.nvim_set_hl(0, "Strike", {
--           strikethrough = true,
--           fg = "Grey",
--           term = "strikethrough",
--           cterm = "strikethrough",
--           gui = "strikethrough",
--         })
--       end,
--     })
--
--     -- Set highlight immediately too
--     vim.api.nvim_set_hl(0, "Strike", {
--       strikethrough = true,
--       fg = "Grey",
--       term = "strikethrough",
--       cterm = "strikethrough",
--       gui = "strikethrough",
--     })
--
--     -- Add pattern match
--     vim.fn.matchadd("Strike", "\\~\\~\\zs.*\\ze\\~\\~")
--   end,
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.api.nvim_set_hl(0, "Strike", { strikethrough = true })
--     vim.fn.matchadd("Strike", "~~\\zs.*\\ze~~")
--   end,
-- })
-- visual color
-- vim.api.nvim_command("hi Visual guifg=#000000 guibg=#33FF00 gui=none")





------------------------------
-- calling automatically neovim starts
------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command("ShowkeysToggle") -- show key toggle
    vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" }) -- Trigger ToggleMyPrompt on VimEnter
  end,
})

-- vim.fn.system("rm -rf ~/.cache/nvim/jdtls/")
vim.api.nvim_command("hi Visual guifg=#000000 guibg=#666699 gui=none")


-- Auto save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
  callback = function()
    -- Only auto save if the buffer is modified, has a file name, and is a normal file buffer
    if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= "" and vim.bo.buftype == "" and vim.bo.buflisted then
      vim.cmd("silent w")
    end
  end,
})


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


-- vim.api.nvim_create_autocmd("User", {
--   pattern = "ToggleMyPrompt",
--   callback = function() require("avante.config").override({system_prompt = "1. Before answering my question, always first rephrase my question into how a native speaker would naturally ask it in English."}) end,
-- })
