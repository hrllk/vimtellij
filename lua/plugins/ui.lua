return {

  -- -------------------------------------------------
  -- Theme
  -- -------------------------------------------------
  {
    "sainnhe/sonokai",
    proiroty = 1000,
    config = function()
      vim.g.sonokai_transparent_background = "1"
      vim.g.sonokai_enable_italic = "1"
      vim.g.sonokai_style = "andromeda"
      vim.cmd.colorscheme("sonokai")
    end,
  },

  -- -------------------------------------------------
  -- noice
  -- for hightlighting
  -- -------------------------------------------------
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

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
    "akinsho/bufferline.nvim",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

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

  {
  --   'nvimdev/dashboard-nvim',
  --   event = 'VimEnter',
  --   config = function()
  --     local logo = [[
  --       ██╗   ██╗██╗███╗   ███╗████████╗███████╗██╗     ██╗     ██╗     ██╗
  --       ██║   ██║██║████╗ ████║╚══██╔══╝██╔════╝██║     ██║     ██║     ██║
  --       ██║   ██║██║██╔████╔██║   ██║   █████╗  ██║     ██║     ██║     ██║
  --       ╚██╗ ██╔╝██║██║╚██╔╝██║   ██║   ██╔══╝  ██║     ██║     ██║██   ██║
  --        ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ███████╗███████╗███████╗██║╚█████╔╝
  --         ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝ ╚════╝ z
  --     ]]
  --     require('dashboard').setup {
  --       -- config
  --       config = {
  --         theme = 'hyper',
  --         header = vim.split(logo, "\n");
  --       }
  --     }
  --   end,
  --   dependencies = { {'nvim-tree/nvim-web-devicons'}}
  -- },
    --


  -- -------------------------------------------------
  -- Dashboard
  -- -------------------------------------------------
    {
      "folke/snacks.nvim",
      ---@type snacks.Config
      opts = {
        dashboard = {

          enabled = true, -- Enable the dashboard
          width = 80, -- Set the width of the dashboard
          row = nil, -- Center the dashboard vertically
          col = nil, -- Center the dashboard horizontally
          pane_gap = 4, -- Space between sections
          autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",

          preset = {
            -- Custom ASCII Header
            header = [[
         ██╗ ██╗██╗███╗ ███╗█████╗████╗ ██╗  ██╗  ██╗   ██╗
         ██║ ██║██║████████║╚██╔═╝██╔═╝ ██║  ██║  ██║   ██║
         ██║ ██║██║██╔██╔██║ ██║  ███╗  ██║  ██║  ██║   ██║
         █████╔╝██║██║╚╔╝██║ ██║  ██╔╝  ██║  ██║  ██║██ ██║
          ███╔╝ ██║██║   ██║ ██║  █████╗████╗████╗██║╚███╔╝
         ╚══╝  ╚═╝╚═╝   ╚═╝ ╚═╝  ╚════╝╚═══╝╚═══╝╚═╝ ╚══╝
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
            {
              pane = 2,
              section = "terminal",
              -- cmd = "colorscript -e square",
              -- cmd = "sl",
              cmd = "cmatrix",
              height = 5,
              padding = 1,
            },
            { section = "keys", gap = 1, padding = 1 },
            { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            {
              pane = 2,
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = "startup" },
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
  --   {
  --     "nvimdev/dashboard-nvim",
  --     lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  --     opts = function()
  --       local logo = [[
  --         ██╗   ██╗██╗███╗   ███╗████████╗███████╗██╗     ██╗     ██╗     ██╗
  --         ██║   ██║██║████╗ ████║╚══██╔══╝██╔════╝██║     ██║     ██║     ██║
  --         ██║   ██║██║██╔████╔██║   ██║   █████╗  ██║     ██║     ██║     ██║
  --         ╚██╗ ██╔╝██║██║╚██╔╝██║   ██║   ██╔══╝  ██║     ██║     ██║██   ██║
  --          ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ███████╗███████╗███████╗██║╚█████╔╝
  --           ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝ ╚════╝
  --       ]]
  --
  --       logo = string.rep("\n", 8) .. logo .. "\n\n"
  --
  --       local opts = {
  --         theme = "doom",
  --         hide = {
  --           -- this is taken care of by lualine
  --           -- enabling this messes up the actual laststatus setting after loading a file
  --           statusline = false,
  --         },
  --         config = {
  --           header = vim.split(logo, "\n"),
  --           -- stylua: ignore
  --           center = {
  --             { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
  --             { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
  --             { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
  --             { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
  --             { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
  --             { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
  --             { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
  --             { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
  --             { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
  --           },
  --           footer = function()
  --             local stats = require("lazy").stats()
  --             local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --             return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
  --           end,
  --         },
  --       }
  --
  --       for _, button in ipairs(opts.config.center) do
  --         button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
  --         button.key_format = "  %s"
  --       end
  --
  --       -- open dashboard after closing lazy
  --       if vim.o.filetype == "lazy" then
  --         vim.api.nvim_create_autocmd("WinClosed", {
  --           pattern = tostring(vim.api.nvim_get_current_win()),
  --           once = true,
  --           callback = function()
  --             vim.schedule(function()
  --               vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
  --             end)
  --           end,
  --         })
  --       end
  --
  --     return opts
  --   end,
  -- },



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
  }
  }
}
