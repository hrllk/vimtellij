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

        hl.SnacksDashboardNormal = { fg = accent, bg = none }
        hl.SnacksDashboardHeader = { fg = accent, bg = none }
        hl.SnacksDashboardIcon = { fg = accent, bg = none }
        hl.SnacksDashboardDesc = { fg = accent, bg = none }
        hl.SnacksDashboardKey = { fg = accent, bg = none, bold = true }
        hl.SnacksDashboardFooter = { fg = accent, bg = none }
        hl.SnacksDashboardTitle = { fg = accent, bg = none }
        hl.SnacksDashboardSpecial = { fg = accent, bg = none }
        hl.SnacksDashboardTerminal = { bg = "#000000" }

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
        for level = 1, 6 do
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", { bg = "NONE" })
        end
      end

      local function force_black_terminal()
        vim.g.terminal_color_0 = "#000000"
        vim.g.terminal_color_8 = "#000000"
        vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", { bg = "#000000" })

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
