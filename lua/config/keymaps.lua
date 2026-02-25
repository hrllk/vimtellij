-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- -------------------------------------------------
-- Global Settings
-- -------------------------------------------------
-- Leader key definition
-- Leader key is set to space. This is a common prefix for custom keybindings.
vim.g.mapleader = ' '

-- Keymap helper functions
local keymap = vim.keymap -- Helper for setting keybindings easily (vim.keymap.set shorthand)
local opts = { noremap = true, silent = true } -- Common options for keymaps: non-recursive and silent execution

-- -------------------------------------------------
-- General Mappings
-- -------------------------------------------------

-- increment/decrement numbers under cursor
keymap.set("n", "+", "<C-a>") -- Increment number
keymap.set("n", "-", "<C-x>") -- Decrement number

-- scroll the viewport up/down without moving cursor
keymap.set("n", "<M-j>", "<C-e>") -- Scroll viewport down (keep cursor fixed)
keymap.set("n", "<M-k>", "<C-y>") -- Scroll viewport up (keep cursor fixed)

-- custom jumplist backward navigation (g[)
vim.keymap.set("n", "g[", function()
  local key = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
  vim.api.nvim_feedkeys(key, "n", false)
end, { noremap = true, silent = true })

-- custom jumplist forward navigation (g])
vim.keymap.set("n", "g]", function()
  local key = vim.api.nvim_replace_termcodes("<C-i>", true, false, true)
  vim.api.nvim_feedkeys(key, "n", false)
end, { noremap = true, silent = true })

-- clear search highlights
keymap.set("n", "<esc>", ":noh<CR>", opts)

-- delete character under cursor without yanking it
keymap.set("n", "x", '"_x')

-- -------------------------------------------------
-- ui
-- -------------------------------------------------

-- pane
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- tab
keymap.set("n", "te", ":tabedit <Return>", opts)
keymap.set("n", "to", ":tabonly <Return>", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- -------------------------------------------------
-- editing
-- -------------------------------------------------
keymap.set("v", ";ccs", ":s/\\(\\l\\)\\(\\u\\)/\\1_\\l\\2/gc<CR>") -- snake to camel
keymap.set("v", ";csc", ":s/_\\(\\l\\)/\\u\\1/gc<CR>") -- camel to snake
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set("v", ">", ">gv", opts)
keymap.set("v", "<", "<gv", opts)

-- -------------------------------------------------
-- plugins
-- -------------------------------------------------

-- rest run
keymap.set("n", "rr", "<Cmd>Rest run<CR>", opts)

-- jdtls
keymap.set("n", "<C-A-r>", function() require("springboot-nvim").boot_run() end, opts)
keymap.set("n", "<C-A-l>", ":JavaRunnerToggleLogs<CR>", opts)
keymap.set("n", "+", ":resize +5<CR>", opts)
keymap.set("n", "_", ":resize -5<CR>", opts)

-- lsp
keymap.set("n", "<C-A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
