-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- inc/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backworkd
-- keymap.set("n", "dw", "vb_d")

-- select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- new tab
keymap.set("n", "te", ":tabedit <Return>", opts)
keymap.set("n", "to", ":tabonly <Return>", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- move window
-- keymap.set("n", "sh", "<C-w>h", opts)
-- keymap.set("n", "sk", "<C-w>k", opts)
-- keymap.set("n", "sj", "<C-w>j", opts)
-- keymap.set("n", "sl", "<C-w>l", opts)
-- keymap.set("n", "<C-w><left>", "<C-w><", opts)
-- keymap.set("n", "<C-w><right>", "<C-w>>", opts)
-- keymap.set("n", "<C-w><up>", "<C-w>+", opts)
-- keymap.set("n", "<C-w><down>", "<C-w>-", opts)

-- lsp
keymap.set("n", "<leader>O", ":lua vim.lsp.buf.code_action()<CR>", opts)
keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
-- keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "x", '"_x')



-- eidtor 
keymap.set("v", ";csc", ":s/\\(\\l\\)\\(\\u\\)/\\1_\\l\\2/gc")
keymap.set("v", ";ccs", ":s/_\\(\\l\\)/\\u\\1/gc")
--
