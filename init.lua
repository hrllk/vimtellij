-- if vim.loader then
--   vim.loader.enable()
-- end
--
-- _G.dd = function(...)
--   require("util.debug").dump(...)
-- end
-- vim.print = _G.dd

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- For init.lua
vim.g.neovide_transparency = 0.95
vim.g.neovide_cursor_vfx_mode = 'railgun'

vim.g.neovide_cursor_vfx_mode = ''
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_length = 0.0
vim.g.neovide_no_idle = true


vim.g.neovim_font='Noto Sans KR:h12'
