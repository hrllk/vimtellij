return {

-- -------------------------------------------------
-- Themes
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

  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("onedarkpro").setup({
  --       options = {
  --         transparency = true,
  --       }
  --     })
  --
  --     vim.cmd.colorscheme("onedark_dark")
  --   end,
  -- },

  -- {
  --   "miikanissi/modus-themes.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --     variant = "default",
  --     styles = {
  --       comments = { italic = false },
  --       keywords = { italic = false },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("modus-themes").setup(opts)
  --     vim.cmd.colorscheme("modus_vivendi")
  --   end,
  -- },
  --
 
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   lazy = false,
  --   opts = {
  --     flavour = "mocha",
  --
  --     transparent_background = true,
  --
  --     float = {
  --       transparent = true,
  --       solid = false,
  --     },
  --
  --     integrations = {
  --       snacks = {
  --         enabled = true,
  --       },
  --     },
  --
  --     custom_highlights = function(colors)
  --       return {
  --         Normal = { bg = colors.none },
  --         NormalNC = { bg = colors.none },
  --         NormalFloat = { bg = colors.none },
  --         FloatBorder = { bg = colors.none },
  --         FloatTitle = { bg = colors.none },
  --         SignColumn = { bg = colors.none },
  --         EndOfBuffer = { bg = colors.none },
  --
  --         SnacksNormal = { bg = colors.none },
  --         SnacksNormalNC = { bg = colors.none },
  --
  --         SnacksPicker = { bg = colors.none },
  --         SnacksPickerInput = { bg = colors.none },
  --         SnacksPickerList = { bg = colors.none },
  --         SnacksPickerPreview = { bg = colors.none },
  --
  --         SnacksPickerBorder = { bg = colors.none },
  --         SnacksPickerInputBorder = { bg = colors.none },
  --         SnacksPickerListBorder = { bg = colors.none },
  --         SnacksPickerPreviewBorder = { bg = colors.none },
  --
  --         SnacksPickerTitle = { bg = colors.none },
  --       }
  --     end,
  --   },
  --   config = function(_, opts)
  --     require("catppuccin").setup(opts)
  --     vim.cmd.colorscheme("catppuccin-mocha")
  --   end,
  -- },
  
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,

      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = false },
        keywords = { italic = false },
      },

      on_highlights = function(hl, c)
        local none = "NONE"

        hl.Normal = { bg = none }
        hl.NormalNC = { bg = none }
        hl.NormalFloat = { bg = none }
        hl.FloatBorder = { fg = "#0F766E", bg = none }
        hl.FloatTitle = { bg = none }
        hl.SignColumn = { bg = none }
        hl.EndOfBuffer = { bg = none }
        hl.WinSeparator = { fg = "#2DD4BF", bg = none }

        -- dashboard 본체
        hl.SnacksDashboardNormal = { bg = none }

        -- terminal section 자체는 검정 고정
        hl.SnacksDashboardTerminal = { bg = "#000000" }

        -- snacks picker/explorer
        hl.SnacksNormal = { bg = none }
        hl.SnacksNormalNC = { bg = none }
        hl.SnacksWinSeparator = { fg = "#0F766E", bg = none }
        hl.SnacksPicker = { bg = none }
        hl.SnacksPickerInput = { bg = none }
        hl.SnacksPickerList = { bg = none }
        hl.SnacksPickerPreview = { bg = none }
        hl.SnacksPickerBorder = { fg = "#0F766E", bg = none }
        hl.SnacksPickerInputBorder = { fg = "#0F766E", bg = none }
        hl.SnacksPickerListBorder = { fg = "#0F766E", bg = none }
        hl.SnacksPickerPreviewBorder = { fg = "#0F766E", bg = none }
        hl.SnacksPickerTitle = { bg = none }

        -- render-markdown markdown view
        hl.RenderMarkdownH1Bg = { bg = none }
        hl.RenderMarkdownH2Bg = { bg = none }
        hl.RenderMarkdownH3Bg = { bg = none }
        hl.RenderMarkdownH4Bg = { bg = none }
        hl.RenderMarkdownH5Bg = { bg = none }
        hl.RenderMarkdownH6Bg = { bg = none }
        hl.RenderMarkdownCode = { bg = none }
        hl.RenderMarkdownCodeBorder = { fg = "#0F766E", bg = none }
        hl.RenderMarkdownCodeInfo = { bg = none }
        hl.RenderMarkdownCodeInline = { bg = none }
      end,
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")

      local function clear_markdown_backgrounds()
        vim.api.nvim_set_hl(0, "@markup.raw", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "@markup.raw.block", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { fg = "#0F766E", bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "NONE" })
      end

      local function force_black_terminal()
        -- 핵심: Neovim 내장 터미널의 ANSI black / bright black을 순수 검정으로 고정
        vim.g.terminal_color_0 = "#000000"
        vim.g.terminal_color_8 = "#000000"

        vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", {
          bg = "#000000",
        })

        -- Snacks dashboard terminal section은 별도 floating window로 뜨므로,
        -- 생성된 뒤 한 번 더 window highlight를 강제
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
          local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)

          if ok_cfg and ok_buf and cfg.relative ~= "" then
            local ft = vim.bo[buf].filetype

            if ft == "snacks_dashboard" then
              vim.api.nvim_set_option_value(
                "winhighlight",
                table.concat({
                  "Normal:SnacksDashboardTerminal",
                  "NormalFloat:SnacksDashboardTerminal",
                  "TermCursorNC:SnacksDashboardTerminal",
                }, ","),
                { win = win }
              )

              vim.api.nvim_set_option_value("winblend", 0, { win = win })
            end
          end
        end
      end

      clear_markdown_backgrounds()
      force_black_terminal()

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = function()
          clear_markdown_backgrounds()
          vim.schedule(force_black_terminal)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = {
          "SnacksDashboardOpened",
          "SnacksDashboardUpdatePost",
        },
        callback = function()
          vim.defer_fn(force_black_terminal, 20)
        end,
      })
    end,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     style = "moon",
  --     transparent = true,
  --     terminal_colors = true,
  --   },
  --   config = function(_, opts)
  --     require("tokyonight").setup(opts)
  --     vim.cmd.colorscheme("tokyonight-moon")
  --   end,
  -- },
  
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     vim.cmd.colorscheme("onedark_dark")
  --   end,
  -- },

-- -------------------------------------------------
-- noice (for hightlighting)
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
-- notify popup (upsage :lua print('hey'))
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
-- animate
-- -------------------------------------------------
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

-- -------------------------------------------------
-- Dashboard
-- -------------------------------------------------
  {
    "folke/snacks.nvim",
    lazy = false, -- Ensure it loads on startup for the dashboard
    ---@type snacks.Config
    opts = {
      -- picker = {
      --
      -- },
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
          
          {
            section = "terminal",
            -- cmd = "printf '\\033[48;2;0;0;0m\\033[2J\\033[H'; asciiquarium -u 6",
            cmd = "asciiquarium -u 6",
            random = 10,
            pane = 2,
            indent = 4,
            height = 30,
          },

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
      },
    },
    keys = {
      {
        "<leader>th",
        function()
          require("snacks").picker.colorschemes({ layout = "ivy" })
        end,
        desc = "Pick Color Schemes",
      }
    }
  },

-- -------------------------------------------------
-- filename
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

-- -------------------------------------------------
-- which key
-- -------------------------------------------------
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

-- -------------------------------------------------
-- markdown preview
-- -------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

-- -------------------------------------------------
-- diagram
-- -------------------------------------------------
  -- { -- mermaid render dependency
  --   "3rd/diagram.nvim",
  --   dependencies = {
  --     "3rd/image.nvim",
  --   },
  --   opts = { -- you can just pass {}, defaults below
  --
  --   },
  -- },

-- -------------------------------------------------
-- nvim pane hightlight
-- -------------------------------------------------
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  }
}
