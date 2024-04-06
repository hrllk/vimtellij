return {
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

  -- notify popup
  -- upsage :lua print('hey')
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      background_color = "#000000",
      render = "wrapped-compact",
    },
  },

  -- buffer line tab
  -- tab swicher
  -- usage: te 생성후
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

  -- animation
  -- can see cusor jumped up
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- logo
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

  -- file name in multiple pane
  -- {
  --   "b0o/include.nvim",
  --   dependencies = { "craftzdog/solarized-osaka.nvim" },
  --   event = "BufReadPre",
  --   priority = 1200,
  --   config = function()
  --     local colors = require("solarized-osak.colors").setup()
  --     require("include").setup({
  --
  --       highlight = {
  --         groups = {
  --           inclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
  --           inclineNomalNC = { guifg = colors.violet500, guibg = colors.base03 },
  --         },
  --       },
  --       window = { margin = { vertical = 0, horizontal = 1 } },
  --       hide = {
  --         cursorline = true,
  --       },
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  --       end,
  --     })
  --   end,
  -- },
}
