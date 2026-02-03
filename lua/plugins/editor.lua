return {
  -- -------------------------------------------------
  -- inc-rename
  -- for rename (refactor)
  -- -------------------------------------------------
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Incremental rename",
        mode = "n",
        noremap = true,
        expr = true,
      },
    },
    config = true,
  },
  -- -------------------------------------------------
  -- tab
  -- -------------------------------------------------
  {
    'nanozuki/tabby.nvim',
    ---@type TabbyConfig
    opts = {
      -- configs...
    },
  },

  -- init.lua:
  -- -------------------------------------------------
  -- snack nvim related with editor
  -- picker, explorer, image
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      image = {}, -- required magick (install with homebrew)
      explorer = {},
      picker = {
      },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" }, -- hidden option
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    }
  },

  -- -------------------------------------------------
  -- Highlight colors
  -- -------------------------------------------------
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },


  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- ts-autotag utilizes treesitter to understand the code structure to automatically close tsx tags
      "windwp/nvim-ts-autotag"
    },
    -- when the plugin builds run the TSUpdate command to ensure all our servers are installed and updated
    build = ':TSUpdate',
    config = function()
      -- gain access to the treesitter config functions
      local ts_config = require("nvim-treesitter.configs")

      -- call the treesitter setup function with properties to configure our experience
      ts_config.setup({
        -- make sure we have vim, vimdoc, lua, java, javascript, typescript, html, css, json, tsx, markdown, markdown, inline markdown and gitignore highlighting servers
        ensure_installed = { "vim", "vimdoc", "lua", "java", "javascript", "typescript", "html", "css", "json", "tsx", "markdown", "markdown_inline", "gitignore", "sql", "http", "nginx" },
        -- make sure highlighting it anabled
        highlight = { enable = true },
        -- enable tsx auto closing tag creation
        autotag = {
          enable = true
        }
      })
    end
  },

  -- -------------------------------------------------
  -- Markdown Render
  -- -------------------------------------------------
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },



  -- -------------------------------------------------
  -- comment
  -- for commenting
  -- -------------------------------------------------
  -- {
  --   "numtostr/comment.nvim",
  --   opts = {
  --     -- add any options here
  --   },
  -- },

  -- -------------------------------------------------
  -- todo comment
  -- for todo commenting as below
  -- TODO :,
  -- WARN :...
  -- -------------------------------------------------
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      {
        signs = true,      -- show icons in the signs column
        sign_priority = 8, -- sign priority
        -- keywords recognized as todo comments
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
      },
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- -------------------------------------------------
  -- undo tree
  -- undo list, move it
  -- -------------------------------------------------
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
  -- -------------------------------------------------
  -- harpoon
  -- navigating
  -- -------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      -- Set a vim motion to <Shift>m to mark a file with harpoon
      vim.keymap.set("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Harpoon Mark File" })
      -- Set a vim motion to the tab key to open the harpoon menu to easily navigate frequented files
      vim.keymap.set("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
        { desc = "Harpoon Toggle Menu" })
    end
  },


  -- -------------------------------------------------
  -- Mini File
  -- -------------------------------------------------
  -- { "echasnovski/mini.nvim", version = false },
  -- {
  --   "echasnovski/mini.files",
  --   config = function()
  --     local MiniFiles = require("mini.files")
  --     MiniFiles.setup({
  --       mappings = {
  --         go_in = "<CR>",
  --         go_in_plus = "L",
  --         go_out = "-",
  --         go_out_plus = "H",
  --       },
  --     })
  --     vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file" })
  --     vim.keymap.set("n", "<leader>ef", function()
  --       MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  --       MiniFiles.reveal_cwd()
  --     end, { desc = "Toggle into currently opened file" })
  --   end,
  -- },

  -- -------------------------------------------------
  -- Tmux navigator
  -- -------------------------------------------------
  {
    "christoomey/vim-tmux-navigator",
  },

  -- -------------------------------------------------
  -- show keys
  -- -------------------------------------------------
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      maxkeys = 3,
      show_count = true,
      winopts = {
        focusable = false,
        relative = "editor",
        style = "minimal",
        border = "single",
        height = 1,
        row = 1,
        col = 0,
      },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        theme = 'auto', -- lualine theme
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {}, -- only ignores the ft for statusline.
          winbar = {},   -- only ignores the ft for winbar.
        },

        ignore_focus = {}, -- If current filetype is in this list it'll
        -- always be drawn as inactive statusline
        -- and the last window will be drawn as active statusline.
        -- for example if you don't want statusline of
        -- your file tree / sidebar window to have active
        -- statusline you can add their filetypes here.
        --
        -- Can also be set to a function that takes the
        -- currently focused window as its only argument
        -- and returns a boolean representing whether the
        -- window's statusline should be drawn as inactive.

        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.

        always_show_tabline = true, -- When set to true, if you have configured lualine for displaying tabline
        -- then tabline will always show. If set to false, then tabline will be displayed
        -- only when there are more than 1 tab. (see :h showtabline)

        globalstatus = false, -- enable global statusline (have a single statusline
        -- at bottom of neovim instead of one for  every window).
        -- This feature is only available in neovim 0.7 and higher.

        refresh = {    -- sets how often lualine should refresh it's contents (in ms)
          statusline = 100, -- The refresh option sets minimum time that lualine tries
          tabline = 100, -- to maintain between refresh. It's not guarantied if situation
          winbar = 100, -- arises that lualine needs to refresh itself before this time
          -- it'll do it.
          refresh_time = 16, -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
          events = {   -- The auto command events at which lualine refreshes
            'WinEnter',
            'BufEnter',
            'BufWritePost',
            'SessionLoadPost',
            'FileChangedShellPost',
            'VimResized',
            'Filetype',
            'CursorMoved',
            'CursorMovedI',
            'ModeChanged',
          },
          -- Also you can force lualine's refresh by calling refresh function
          -- like require('lualine').refresh()
        }
      })
    end,
  },

  -- -------------------------------------------------
  -- formatter <leader>cf
  -- -------------------------------------------------
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      -- get access to the none-ls functions
      local null_ls = require("null-ls")
      -- run the setup function for none-ls to setup our different formatters
      null_ls.setup({
        sources = {
          -- setup lua formatter
          null_ls.builtins.formatting.stylua,
          -- setup eslint linter for javascript
          require("none-ls.diagnostics.eslint_d"),
          -- setup prettier to format languages that are not lua
          null_ls.builtins.formatting.prettier
        }
      })

      -- set up a vim motion for <Space> + c + f to automatically format our code based on which langauge server is active
      vim.keymap.set({ "n", "v" }, "<leader>cf", vim.lsp.buf.format, { desc = "[C]ode [F]ormat" })
    end

  },

  -- -------------------------------------------------
  -- autopairs
  -- auto closeable {} [] ()
  -- -------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- Call the autopairs setup function to configure how we want autopairs to work
      require 'nvim-autopairs'.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        }
      })

      -- Get access to auto pairs completion and cmp plugins
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      -- Whenever we accept a choice from an autocompletion, make sure that any pairs are automatically closed
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  },
  -- -------------------------------------------------
  -- supermaven
  -- -------------------------------------------------
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  }

}
