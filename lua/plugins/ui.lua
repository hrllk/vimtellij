return {
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
  -- animation
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
  -- dashboard logo
  -- -------------------------------------------------
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
        ██╗   ██╗██╗███╗   ███╗████████╗███████╗██╗     ██╗     ██╗     ██╗
        ██║   ██║██║████╗ ████║╚══██╔══╝██╔════╝██║     ██║     ██║     ██║
        ██║   ██║██║██╔████╔██║   ██║   █████╗  ██║     ██║     ██║     ██║
        ╚██╗ ██╔╝██║██║╚██╔╝██║   ██║   ██╔══╝  ██║     ██║     ██║██   ██║
        ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ███████╗███████╗███████╗██║╚█████╔╝
        ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝ ╚════╝ 
                                                                   
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
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

  -- -------------------------------------------------
	-- LazyGit integration with Telescope
  -- -------------------------------------------------
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{
				";c",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},




  -- -------------------------------------------------
  -- DB TOOL
  -- -------------------------------------------------
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		keys = {
			{

				"<leader>d",
				"<cmd>tabnew<cr><bar><bar><cmd>DBUI<cr>",
			},
		},
	},
}
