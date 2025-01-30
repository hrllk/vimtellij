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
  --       ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ███████╗███████╗███████╗██║╚█████╔╝
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


  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      local logo = [[
        ██╗   ██╗██╗███╗   ███╗████████╗███████╗██╗     ██╗     ██╗     ██╗
        ██║   ██║██║████╗ ████║╚══██╔══╝██╔════╝██║     ██║     ██║     ██║
        ██║   ██║██║██╔████╔██║   ██║   █████╗  ██║     ██║     ██║     ██║
        ╚██╗ ██╔╝██║██║╚██╔╝██║   ██║   ██╔══╝  ██║     ██║     ██║██   ██║
        ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ███████╗███████╗███████╗██║╚█████╔╝
          ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝ ╚════╝
      ]]
      require('dashboard').setup {
        -- config
        theme = 'hyper',
        header = vim.split(logo, "\n");
      }
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
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
