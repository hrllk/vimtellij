local function refresh_markdown_preview_mermaid(plugin_dir)
  local target = plugin_dir .. "/app/_static/mermaid.min.js"
  local mermaid_url = "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"

  if vim.g.__markdown_preview_mermaid_patched then
    return
  end

  if vim.fn.executable("curl") == 1 then
    vim.fn.system({ "curl", "-fsSL", mermaid_url, "-o", target })
  elseif vim.fn.executable("wget") == 1 then
    vim.fn.system({ "wget", "-qO", target, mermaid_url })
  end

  vim.g.__markdown_preview_mermaid_patched = true
end

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
        local accent = c.gray

        hl.Normal = { bg = none }
        hl.NormalNC = { bg = none }
        hl.NormalFloat = { bg = none }
        hl.FloatBorder = { fg = "#0F766E", bg = none }
        hl.FloatTitle = { bg = none }
        hl.SignColumn = { bg = none }
        hl.EndOfBuffer = { bg = none }
        hl.WinSeparator = { fg = "#2DD4BF", bg = none }

        -- dashboard 본체
        hl.SnacksDashboardNormal = { fg = accent, bg = none }
        hl.SnacksDashboardHeader = { fg = accent, bg = none }
        hl.SnacksDashboardIcon = { fg = accent, bg = none }
        hl.SnacksDashboardDesc = { fg = accent, bg = none }
        hl.SnacksDashboardKey = { fg = accent, bg = none, bold = true }
        hl.SnacksDashboardFooter = { fg = accent, bg = none }
        hl.SnacksDashboardTitle = { fg = accent, bg = none }
        hl.SnacksDashboardSpecial = { fg = accent, bg = none }

        -- terminal section 자체는 검정 고정
        hl.SnacksDashboardTerminal = { bg = "#000000" }

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
        hl.RenderMarkdownCodeInline = { fg = "#2DD4BF", bg = "#0B1220", bold = true }
      end,
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")

      local function clear_markdown_backgrounds()
        vim.api.nvim_set_hl(0, "@markup.raw", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "@markup.raw.block", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = "#2DD4BF", bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = "#2DD4BF", bg = "#0B1220", bold = true })
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
-- dashboard
-- -------------------------------------------------
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "amansingh-afk/milli.nvim" },
    opts = function()
      local splash = require("milli").load({ splash = "ididnot" })
      return {
        dashboard = {
          enabled = true,
          preset = {
            header = table.concat(splash.frames[1], "\n"),
            keys = {
              {
                action = ":lua Snacks.dashboard.pick('files')",
                key = "f",
                text = {
                  { " ", hl = "SnacksDashboardIcon" },
                  { "Find File", hl = "SnacksDashboardDesc", width = 50 },
                  { "f", hl = "SnacksDashboardKey" },
                },
              },
              {
                action = ":lua Snacks.dashboard.pick('oldfiles')",
                key = "r",
                text = {
                  { " ", hl = "SnacksDashboardIcon" },
                  { "Recent Files", hl = "SnacksDashboardDesc", width = 50 },
                  { "r", hl = "SnacksDashboardKey" },
                },
              },
              {
                action = ":Lazy",
                key = "L",
                enabled = package.loaded.lazy ~= nil,
                text = {
                  { "󰒲 ", hl = "SnacksDashboardIcon" },
                  { "Lazy", hl = "SnacksDashboardDesc", width = 50 },
                  { "L", hl = "SnacksDashboardKey" },
                },
              },
              {
                action = ":qa",
                key = "q",
                text = {
                  { " ", hl = "SnacksDashboardIcon" },
                  { "Quit", hl = "SnacksDashboardDesc", width = 50 },
                  { "q", hl = "SnacksDashboardKey" },
                },
              },
            },
          },
          sections = {
            { section = "header", padding = 1 },
            { section = "keys",   gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("snacks").setup(opts)
      local milli_runtime = require("milli.runtime")
      local splash_opts = { splash = "ididnot", loop = true }
      local milli_ns = vim.api.nvim_create_namespace("milli_dashboard_splash")
      local splash_state = {}
      local hl_cache = {}

      local function get_hl(fg_hex, bg_hex)
        local key = fg_hex .. "_" .. bg_hex
        if hl_cache[key] then
          return hl_cache[key]
        end
        local bg_suffix = bg_hex == "NONE" and "NONE" or bg_hex:sub(2)
        local name = "MilliSplash_" .. fg_hex:sub(2) .. "_" .. bg_suffix
        local spec = { fg = fg_hex }
        if bg_hex ~= "NONE" then
          spec.bg = bg_hex
        end
        vim.api.nvim_set_hl(0, name, spec)
        hl_cache[key] = name
        return name
      end

      local function rtrim(s)
        return (s:gsub("%s+$", ""))
      end

      local function anchor_in_frame0(data)
        local first = data.frames and data.frames[1]
        if not first then
          return nil, nil
        end
        for i, line in ipairs(first) do
          if line:find("[^%s]") then
            return i, line
          end
        end
        return nil, nil
      end

      local function paint_dashboard_splash(buf, token, data, start_row, pad)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local pad_bytes = #pad
        local function paint(idx)
          if not vim.api.nvim_buf_is_valid(buf) then
            return false
          end
          local state = splash_state[buf]
          if not state or state.token ~= token then
            return false
          end

          local frame = data.frames[idx + 1]
          local colors = data.colors and data.colors[idx + 1]
          if not frame then
            return false
          end

          local padded = {}
          for i, line in ipairs(frame) do
            padded[i] = pad .. line
          end

          vim.bo[buf].modifiable = true
          pcall(vim.api.nvim_buf_set_lines, buf, start_row, start_row + #padded, false, padded)
          vim.bo[buf].modified = false
          vim.bo[buf].modifiable = false

          vim.api.nvim_buf_clear_namespace(buf, milli_ns, 0, -1)
          if not colors then
            return true
          end

          for row_i, row_runs in ipairs(colors) do
            local buf_row = start_row + row_i - 1
            for _, run in ipairs(row_runs) do
              local sb, eb, fg, bg = run[1], run[2], run[3], run[4]
              local hl = get_hl(fg, bg)
              pcall(vim.api.nvim_buf_set_extmark, buf, milli_ns, buf_row, pad_bytes + sb, {
                end_col = pad_bytes + eb,
                hl_group = hl,
                priority = 200,
              })
            end
          end

          return true
        end

        paint(0)

        local idx = 1
        local function step()
          if not vim.api.nvim_buf_is_valid(buf) then
            return
          end
          local state = splash_state[buf]
          if not state or state.token ~= token then
            return
          end
          if idx >= #data.frames and not splash_opts.loop then
            return
          end
          local fi = idx % #data.frames
          paint(fi)
          idx = idx + 1
          local delay = data.delays[fi + 1] or 100
          vim.defer_fn(step, delay)
        end

        vim.defer_fn(step, data.delays[1] or 100)
      end

      local function attach_dashboard_splash()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype ~= "snacks_dashboard" then
          for _, candidate in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(candidate) and vim.bo[candidate].filetype == "snacks_dashboard" then
              buf = candidate
              break
            end
          end
          if vim.bo[buf].filetype ~= "snacks_dashboard" then
            return
          end
        end

        local state = splash_state[buf] or { token = 0 }
        splash_state[buf] = state
        state.token = state.token + 1
        local token = state.token

        local ok, data = pcall(milli_runtime.load, splash_opts)
        if not ok or not data or not data.frames then
          return
        end

        local anchor_idx, anchor_line = anchor_in_frame0(data)
        if not anchor_idx then
          return
        end

        local anchor_trim = rtrim(anchor_line)
        vim.api.nvim_buf_clear_namespace(buf, milli_ns, 0, -1)

        local function locate()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          for i, line in ipairs(lines) do
            local pos = line:find(anchor_trim, 1, true)
            if pos then
              return i - anchor_idx, line:sub(1, pos - 1)
            end
          end
          return nil, nil
        end

        local function start(attempt)
          if not vim.api.nvim_buf_is_valid(buf) then
            return
          end
          if not splash_state[buf] or splash_state[buf].token ~= token then
            return
          end

          local start_row, pad = locate()
          if not start_row then
            if attempt < 20 then
              vim.defer_fn(function()
                start(attempt + 1)
              end, 25)
            end
            return
          end

          paint_dashboard_splash(buf, token, data, start_row, pad)
        end

        start(0)

        if not state.attached then
          state.attached = true
          vim.api.nvim_buf_attach(buf, false, {
            on_detach = function()
              splash_state[buf] = nil
            end,
          })
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = {
          "SnacksDashboardOpened",
          "SnacksDashboardUpdatePost",
        },
        callback = function()
          vim.schedule(attach_dashboard_splash)
        end,
      })

      local function apply_dashboard_highlights()
        local accent = "#A1A1AA"
        local none = "NONE"

        vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { fg = accent, bg = none })
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = accent, bg = none })
        vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = accent, bg = none })
        vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = accent, bg = none })
        vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = accent, bg = none, bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = accent, bg = none })
        vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = accent, bg = none })
        vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = accent, bg = none })
      end

      apply_dashboard_highlights()

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = function()
          apply_dashboard_highlights()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = {
          "SnacksDashboardOpened",
          "SnacksDashboardUpdatePost",
        },
        callback = function()
          vim.schedule(apply_dashboard_highlights)
        end,
      })
    end,
  },
  -- {
  --   "folke/snacks.nvim",
  --   lazy = false, -- Ensure it loads on startup for the dashboard
  --   ---@type snacks.Config
  --   opts = {
  --     -- picker = {
  --     --
  --     -- },
  --     dashboard = {
  --       enabled = true, -- Enable the dashboard
  --       width = 80,     -- Set the width of the dashboard
  --       row = nil,      -- Center the dashboard vertically
  --       col = nil,      -- Center the dashboard horizontally
  --       pane_gap = 4,   -- Space between sections
  --      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  --
  --       preset = {
  --         -- Custom ASCII Header
  --         header = [[
  --       ██╗ ██╗██╗███╗ ███╗████╗████╗██╗  ██╗  ██╗   ██╗
  --       ██║ ██║██║████████║╚██╔╝██╔═╝██║  ██║  ██║   ██║
  --       ██║ ██║██║██╔██╔██║ ██║ ███╗ ██║  ██║  ██║   ██║
  --       █████╔╝██║██║╚╔╝██║ ██║ ██╔╝ ██║  ██║  ██║██ ██║
  --        ███╔╝ ██║██║   ██║ ██║ ████╗████╗████╗██║╚███╔╝
  --        ╚══╝  ╚═╝╚═╝   ╚═╝ ╚═╝ ╚═══╝╚═══╝╚═══╝╚═╝ ╚══╝
  --         ]],
  --
  --         -- Key mappings on the dashboard
  --         keys = {
  --           { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
  --           { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
  --           { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
  --           { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
  --           { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
  --           { icon = " ", key = "s", desc = "Restore Session", section = "session" },
  --           { icon = "󰒲 ", key = "L", desc = "Lazy Plugins", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
  --           { icon = " ", key = "q", desc = "Quit", action = ":qa" },
  --
  --         }
  --       },
  --
  --
  --       -- Sections Layout
  --       sections = {
  --         { section = "header" },
  --         { section = "keys",  gap = 1, padding = 1 },
  --
  --         -- {
  --         --   section = "terminal",
  --         --   -- cmd = "printf '\\033[48;2;0;0;0m\\033[2J\\033[H'; asciiquarium -u 6",
  --         --   cmd = "asciiquarium -u 6",
  --         --   random = 10,
  --         --   pane = 2,
  --         --   indent = 4,
  --         --   height = 30,
  --         -- },
  --
  --       },
  --
  --       -- Formatting Customization
  --       formats = {
  --         icon = function(item)
  --           return { item.icon, width = 2, hl = "icon" }
  --         end,
  --         footer = { "%s", align = "center" },
  --         header = { "%s", align = "center" },
  --         file = function(item, ctx)
  --           local fname = vim.fn.fnamemodify(item.file, ":~")
  --           fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
  --           return { { fname, hl = "file" } }
  --         end,
  --       },
  --     },
  --   },
  --   keys = {
  --     {
  --       "<leader>th",
  --       function()
  --         require("snacks").picker.colorschemes({ layout = "ivy" })
  --       end,
  --       desc = "Pick Color Schemes",
  --     }
  --   }
  -- },
  
  
  
  

  -- {
  --   "folke/snacks.nvim",
  --   lazy = false, -- Ensure it loads on startup for the dashboard
  --   ---@type snacks.Config
  --   opts = {
  --     dashboard = {
  --       enabled = true,
  --       width = vim.o.columns,
  --       row = nil,
  --       col = nil,
  --       pane_gap = 0,
  --       autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  --       sections = {
  --         {
  --           section = "terminal",
  --           cmd = "asciiquarium -u 6",
  --           width = vim.o.columns,
  --           height = math.max(20, vim.o.lines - 6),
  --           padding = 0,
  --           indent = 0,
  --         },
  --       },
  --     },
  --   },
  -- },

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
    build = function(plugin)
      local plugin_dir = (plugin and plugin.dir) or (vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim")

      vim.fn.system({ "sh", "-c", "cd " .. vim.fn.shellescape(plugin_dir .. "/app") .. " && yarn install" })
      refresh_markdown_preview_mermaid(plugin_dir)
    end,
    config = function(plugin)
      local plugin_dir = (plugin and plugin.dir) or (vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim")
      refresh_markdown_preview_mermaid(plugin_dir)
    end,
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
