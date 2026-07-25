return {
  -- -------------------------------------------------
  -- tab
  -- -------------------------------------------------
  {
    'nanozuki/tabby.nvim',
    ---@type TabbyConfig
    opts = {
      -- configs...
    },
  },

  -- init.lua:
  -- -------------------------------------------------
  -- snack nvim related with editor
  -- picker, explorer, image
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
    init = function()
      vim.g.snacks_animate = false

      local function apply_picker_highlights()
        local none = "NONE"

        vim.api.nvim_set_hl(0, "SnacksNormal", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksWinSeparator", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPicker", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerList", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerTitle", { bg = none })
      end

      apply_picker_highlights()

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = function()
          apply_picker_highlights()
        end,
      })
    end,
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" }, -- hidden option
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    }
  },

  -- -------------------------------------------------
  -- Highlight colors
  -- -------------------------------------------------
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },

  -- -------------------------------------------------
  -- comment
  -- for commenting
  -- -------------------------------------------------
  -- {
  --   "numtostr/comment.nvim",
  --   opts = {
  --     -- add any options here
  --   },
  -- },

  -- -------------------------------------------------
  -- Mini File
  -- -------------------------------------------------
  -- { "echasnovski/mini.nvim", version = false },
  -- {
  --   "echasnovski/mini.files",
  --   config = function()
  --     local MiniFiles = require("mini.files")
  --     MiniFiles.setup({
  --       mappings = {
  --         go_in = "<CR>",
  --         go_in_plus = "L",
  --         go_out = "-",
  --         go_out_plus = "H",
  --       },
  --     })
  --     vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file" })
  --     vim.keymap.set("n", "<leader>ef", function()
  --       MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  --       MiniFiles.reveal_cwd()
  --     end, { desc = "Toggle into currently opened file" })
  --   end,
  -- },

  {
    'nvim-lualine/lualine.nvim',
    event = "UIEnter",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        theme = 'auto', -- lualine theme
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {}, -- only ignores the ft for statusline.
          winbar = {},   -- only ignores the ft for winbar.
        },

        ignore_focus = {}, -- If current filetype is in this list it'll
        -- always be drawn as inactive statusline
        -- and the last window will be drawn as active statusline.
        -- for example if you don't want statusline of
        -- your file tree / sidebar window to have active
        -- statusline you can add their filetypes here.
        --
        -- Can also be set to a function that takes the
        -- currently focused window as its only argument
        -- and returns a boolean representing whether the
        -- window's statusline should be drawn as inactive.

        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.

        always_show_tabline = true, -- When set to true, if you have configured lualine for displaying tabline
        -- then tabline will always show. If set to false, then tabline will be displayed
        -- only when there are more than 1 tab. (see :h showtabline)

        globalstatus = false, -- enable global statusline (have a single statusline
        -- at bottom of neovim instead of one for  every window).
        -- This feature is only available in neovim 0.7 and higher.

        refresh = {    -- sets how often lualine should refresh it's contents (in ms)
          statusline = 100, -- The refresh option sets minimum time that lualine tries
          tabline = 100, -- to maintain between refresh. It's not guarantied if situation
          winbar = 100, -- arises that lualine needs to refresh itself before this time
          -- it'll do it.
          refresh_time = 16, -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
          events = {   -- The auto command events at which lualine refreshes
            'WinEnter',
            'BufEnter',
            'BufWritePost',
            'SessionLoadPost',
            'FileChangedShellPost',
            'VimResized',
            'Filetype',
            'CursorMoved',
            'CursorMovedI',
            'ModeChanged',
          },
          -- Also you can force lualine's refresh by calling refresh function
          -- like require('lualine').refresh()
        }
      })
    end,
  },

}
