return {

  -- -------------------------------------------------
  -- Theme
  -- -------------------------------------------------
  -- {
  --   "sainnhe/sonokai",
  --   proiroty = 1000,
  --   config = function()
  --     vim.g.sonokai_transparent_background = "1"
  --     vim.g.sonokai_enable_italic = "1"
  --     vim.g.sonokai_style = "andromeda"
  --     vim.cmd.colorscheme("sonokai")
  --   end,
  -- },

  -- {
  --   "baliestri/aura-theme",
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
  --     vim.cmd([[colorscheme aura-dark]])
  --   end
  -- },

  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    config = function()
      vim.cmd.colorscheme("onedark_dark")
    end,
  },

  -- -------------------------------------------------
  -- noice
  -- for hightlighting
  -- -------------------------------------------------
  {
    "folke/noice.nvim",
    lazy = false,
    opts = function(_, opts)
      -- Ensure opts.routes is a table before inserting
      opts.routes = opts.routes or {}

      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      -- Ensure opts.presets exists before accessing lsp_doc_border (defensive)
      opts.presets = opts.presets or {}
      opts.presets.lsp_doc_border = true
    end,
  },

  -- -------------------------------------------------
  -- notify popup
  -- upsage :lua print('hey')
  -- -------------------------------------------------
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      background_color = "#000000",
      render = "wrapped-compact",
    },
  },

  -- -------------------------------------------------
  -- buffer line tab
  -- tab swicher
  -- usage: te 생성후
  -- -------------------------------------------------
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    keys = {

    },
    -- Move to previous/next
    -- map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    -- map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    --
    -- -- Re-order to previous/next
    -- map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    -- map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
    --
    -- -- Goto buffer in position...
    -- map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
    -- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
    -- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
    -- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
    -- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
    -- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
    -- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
    -- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
    -- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
    -- map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
    --
    -- -- Pin/unpin buffer
    -- map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    --
    -- -- Goto pinned/unpinned buffer
    -- --                 :BufferGotoPinned
    -- --                 :BufferGotoUnpinned
    --
    -- -- Close buffer
    -- map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    --
    -- -- Wipeout buffer
    -- --                 :BufferWipeout
    --
    -- -- Close commands
    -- --                 :BufferCloseAllButCurrent
    -- --                 :BufferCloseAllButPinned
    -- --                 :BufferCloseAllButCurrentOrPinned
    -- --                 :BufferCloseBuffersLeft
    -- --                 :BufferCloseBuffersRight
    --
    -- -- Magic buffer-picking mode
    -- map('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
    -- map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)
    --
    -- -- Sort automatically by...
    -- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    -- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
    -- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    -- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    -- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  -- {
  --     "akinsho/bufferline.nvim",
  --     lazy = false,
  --     event = "VeryLazy",
  --     -- keys = {
  --     --   { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
  --     --   { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
  --     --   { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
  --     --   { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
  --     --   { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
  --     --   { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  --     --   { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
  --     --   { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  --     --   { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
  --     --   { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  --     -- },
  --     opts = {
  --       -- options = {
  --       --   -- stylua: ignore
  --       --   close_command = function(n) Snacks.bufdelete(n) end,
  --       --   -- stylua: ignore
  --       --   right_mouse_command = function(n) Snacks.bufdelete(n) end,
  --       --   diagnostics = "nvim_lsp",
  --       --   always_show_bufferline = false,
  --       --   diagnostics_indicator = function(_, _, diag)
  --       --     local icons = LazyVim.config.icons.diagnostics
  --       --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
  --       --       .. (diag.warning and icons.Warn .. diag.warning or "")
  --       --     return vim.trim(ret)
  --       --   end,
  --       --   offsets = {
  --       --     {
  --       --       filetype = "neo-tree",
  --       --       text = "Neo-tree",
  --       --       highlight = "Directory",
  --       --       text_align = "left",
  --       --     },
  --       --     {
  --       --       filetype = "snacks_layout_box",
  --       --     },
  --       --   },
  --       --   ---@param opts bufferline.IconFetcherOpts
  --       --   get_element_icon = function(opts)
  --       --     return LazyVim.config.icons.ft[opts.filetype]
  --       --   end,
  --       -- },
  --     },
  --     -- config = function(_, opts)
  --     --   require("bufferline").setup(opts)
  --     --   -- Fix bufferline when restoring a session
  --     --   vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  --     --     callback = function()
  --     --       vim.schedule(function()
  --     --         pcall(nvim_bufferline)
  --     --       end)
  --     --     end,
  --     --   })
  --     -- end,
  -- },

  -- -------------------------------------------------
  -- animate
  -- can see cusor jumped up
  -- -------------------------------------------------
  -- {
  --   "echasnovski/mini.animate",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     opts.scroll = {
  --       enable = false,
  --     }
  --   end,
  -- },


  -- -------------------------------------------------
  -- Dashboard
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
    lazy = false, -- Ensure it loads on startup for the dashboard
    ---@type snacks.Config
    opts = {
      picker = {

      },
      dashboard = {
        enabled = true, -- Enable the dashboard
        width = 80,     -- Set the width of the dashboard
        row = nil,      -- Center the dashboard vertically
        col = nil,      -- Center the dashboard horizontally
        pane_gap = 4,   -- Space between sections
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",

        preset = {
          -- Custom ASCII Header
          header = [[
        ██╗ ██╗██╗███╗ ███╗████╗████╗██╗  ██╗  ██╗   ██╗
        ██║ ██║██║████████║╚██╔╝██╔═╝██║  ██║  ██║   ██║
        ██║ ██║██║██╔██╔██║ ██║ ███╗ ██║  ██║  ██║   ██║
        █████╔╝██║██║╚╔╝██║ ██║ ██╔╝ ██║  ██║  ██║██ ██║
         ███╔╝ ██║██║   ██║ ██║ ████╗████╗████╗██║╚███╔╝
         ╚══╝  ╚═╝╚═╝   ╚═╝ ╚═╝ ╚═══╝╚═══╝╚═══╝╚═╝ ╚══╝
          ]],

          -- Key mappings on the dashboard
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy Plugins", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          }
        },

        -- Sections Layout
        sections = {
          { section = "header" },
          { section = "keys",  gap = 1, padding = 1 },

          -- brew install TheZoraiz/ascii-image-converter/ascii-image-converter

          -- {
          --   section = "terminal",
          --   -- cmd = "colorscript -e square",
          --   -- cmd = "sl",
          --   -- cmd = "cmatrix -u 7 -C blue",
          --   -- cmd = "cmatrix -u 6",
          --   -- cmd = "ascii-image-converter ~/.config/nvim/materials/shifu.png -C",
          --   cmd = "ascii-image-converter ~/.config/nvim/materials/pngegg.png -C",
          --   -- cmd = "ascii-image-converter ~/.config/nvim/materials/pngegg2.png -C",
          --   -- height = 50,
          --   -- pane = 1,
          --   -- gap = 1,
          --   -- padding = 1,
          --   -- priority = 100,
          --   -- width = '50%'
          --   random = 10,
          --   pane = 2,
          --   indent = 4,
          --   height = 30,
          -- },

          -- { pane = 2, icon = " ", title = "Recent Files", section = "terminal", indent = 2, padding = 1, cmd = "cmatrix"},
          -- {
          --   title = "Open Issues",
          --   cmd = "gh issue list -L 3",
          --   key = "i",
          --   action = function()
          --     vim.fn.jobstart("gh issue list --web", { detach = true })
          --   end,
          --   icon = " ",
          --   height = 7,
          -- },

          -- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          -- {
          --   pane = 2,
          --   icon = " ",
          --   title = "Git Status",
          --   section = "terminal",
          --   enabled = function()
          --     return Snacks.git.get_root() ~= nil
          --   end,
          --   cmd = "git status --short --branch --renames",
          --   height = 5,
          --   padding = 1,
          --   ttl = 5 * 60,
          --   indent = 3,
          -- },
          -- { section = "startup" },
        },

        -- Formatting Customization
        formats = {
          icon = function(item)
            return { item.icon, width = 2, hl = "icon" }
          end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            return { { fname, hl = "file" } }
          end,
        },
      }
    }
  },



  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },


  -- -------------------------------------------------
  -- filename
  -- print filename top right print
  -- -------------------------------------------------
  {
    "b0o/incline.nvim",
    dependencies = {},
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
            or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#363944",
          }
          return buffer
        end,
      })
    end,
  },


  -- WhichKey helps you remember your Neovim keymaps,
  -- by showing available keybindings in a popup as you type.
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 300
  --   end,
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   },
  -- },
  -- WhichKey helps you remember your Neovim keymaps,
  -- by showing available keybindings in a popup as you type.
  {
    "folke/which-key.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
  ,
  -- {
  --   "3rd/diagram.nvim",
  --   dependencies = {
  --     "3rd/image.nvim",
  --   },
  --   opts = { -- you can just pass {}, defaults below
  --
  --   },
  -- },

}
