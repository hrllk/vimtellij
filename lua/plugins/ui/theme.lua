local colors = require("config.colors")

------------------------------
-- color theme
-- configure TokyoNight colors and custom highlights
------------------------------
return {
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
        local accent = c.gray

        hl.Normal = { bg = colors.none }
        hl.NormalNC = { bg = colors.none }
        hl.NormalFloat = { bg = colors.none }
        hl.FloatBorder = { fg = colors.border, bg = colors.none }
        hl.FloatTitle = { bg = colors.none }
        hl.SignColumn = { bg = colors.none }
        hl.EndOfBuffer = { bg = colors.none }
        hl.WinSeparator = { fg = colors.accent, bg = colors.none }

        hl.SnacksDashboardNormal = { fg = accent, bg = none }
        hl.SnacksDashboardHeader = { fg = accent, bg = none }
        hl.SnacksDashboardIcon = { fg = accent, bg = none }
        hl.SnacksDashboardDesc = { fg = accent, bg = none }
        hl.SnacksDashboardKey = { fg = accent, bg = none, bold = true }
        hl.SnacksDashboardFooter = { fg = accent, bg = none }
        hl.SnacksDashboardTitle = { fg = accent, bg = none }
        hl.SnacksDashboardSpecial = { fg = accent, bg = none }
        hl.SnacksDashboardTerminal = { bg = colors.terminal }

        hl.RenderMarkdownH1Bg = { bg = colors.none }
        hl.RenderMarkdownH2Bg = { bg = colors.none }
        hl.RenderMarkdownH3Bg = { bg = colors.none }
        hl.RenderMarkdownH4Bg = { bg = colors.none }
        hl.RenderMarkdownH5Bg = { bg = colors.none }
        hl.RenderMarkdownH6Bg = { bg = colors.none }
        hl.RenderMarkdownCode = { bg = colors.none }
        hl.RenderMarkdownCodeBorder = { fg = colors.border, bg = colors.none }
        hl.RenderMarkdownCodeInfo = { bg = colors.none }
        hl.RenderMarkdownCodeInline = { fg = colors.accent, bg = colors.terminal_inline, bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")

      local function clear_markdown_backgrounds()
        vim.api.nvim_set_hl(0, "@markup.raw", { bg = colors.none })
        vim.api.nvim_set_hl(0, "@markup.raw.block", { bg = colors.none })
        vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = colors.none })
        vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = colors.accent, bg = colors.none, bold = true })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = colors.accent, bg = colors.terminal_inline, bold = true })
        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = colors.none })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { fg = colors.border, bg = colors.none })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", { bg = colors.none })
        for level = 1, 6 do
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", { bg = colors.none })
        end
      end

      local function force_black_terminal()
        vim.g.terminal_color_0 = colors.terminal
        vim.g.terminal_color_8 = colors.terminal
        vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", { bg = colors.terminal })

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
          local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)
          if ok_cfg and ok_buf and cfg.relative ~= "" and vim.bo[buf].filetype == "snacks_dashboard" then
            vim.api.nvim_set_option_value("winhighlight", table.concat({
              "Normal:SnacksDashboardTerminal",
              "NormalFloat:SnacksDashboardTerminal",
              "TermCursorNC:SnacksDashboardTerminal",
            }, ","), { win = win })
            vim.api.nvim_set_option_value("winblend", 0, { win = win })
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
        pattern = { "SnacksDashboardOpened", "SnacksDashboardUpdatePost" },
        callback = function()
          vim.defer_fn(force_black_terminal, 20)
        end,
      })
    end,
  },
}
