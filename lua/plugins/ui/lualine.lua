return {
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
          refresh_time = 16,
          events = {
            "WinEnter", "BufEnter", "BufWritePost", "SessionLoadPost",
            "FileChangedShellPost", "VimResized", "Filetype", "CursorMoved",
            "CursorMovedI", "ModeChanged",
          },
        },
      })
    end,
  },
}
