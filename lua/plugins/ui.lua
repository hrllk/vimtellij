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


  -- {
  --   'romgrk/barbar.nvim',
  --   dependencies = {
  --     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   init = function() vim.g.barbar_auto_setup = false end,
  --   opts = {
  --     -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
  --     -- animation = true,
  --     -- insert_at_start = true,
  --     -- …etc.
  --   },
  --   version = '^1.0.0', -- optional: only update when a new 1.x version is released
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



  -- {
  --   "nvim-lualine/lualine.nvim",
  --   enabled = false,
  -- },


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
