-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.g.mapleader = ' '

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- inc/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")


-- jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)



-- -------------------------------------------------
-- tapping(tap, split)
-- -------------------------------------------------
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)


keymap.set("n", "te", ":tabedit <Return>", opts)
keymap.set("n", "to", ":tabonly <Return>", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)


-- -------------------------------------------------
-- lsp
-- -------------------------------------------------
keymap.set("n", "<leader>O", ":lua vim.lsp.buf.code_action()<CR>", opts)
keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
-- keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

keymap.set("n", "x", '"_x')








-- buffer navigation
keymap.set("n", "<C-j>", ":bprevious<CR>", opts)
keymap.set("n", "<C-l>", ":bnext<CR>", opts)



-- -------------------------------------------------
-- editing
-- -------------------------------------------------
keymap.set("v", ";ccs", ":s/\\(\\l\\)\\(\\u\\)/\\1_\\l\\2/gc<CR>") -- snake to camel
keymap.set("v", ";csc", ":s/_\\(\\l\\)/\\u\\1/gc<CR>") -- camel to snake

keymap.set("n", "<C-a>", "gg<S-v>G")


-- -------------------------------------------------
-- jdtls
-- note: mac os user should keysetting on iterm2 to ESC2 for use Option key(Alt)
-- -------------------------------------------------
keymap.set("n", "<C-A-r>", ":JavaRunnerRunMain<CR>", opts)
keymap.set("n", "<C-A-s>", ":JavaRunnerStopMain<CR>", opts)

keymap.set("n", "<C-A-l>", ":JavaRunnerToggleLogs<CR>", opts)
keymap.set("n", "+", ":resize +5<CR>", opts)
keymap.set("n", "_", ":resize -5<CR>", opts)


