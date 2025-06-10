return {
  -- -------------------------------------------------
  -- inc-rename
  -- for rename (refactor)
  -- -------------------------------------------------
  -- {
  --   "smjonas/inc-rename.nvim",
  --   cmd = "IncRename",
  --   keys = {
  --     {
  --       "<leader>rn",
  --       function()
  --         return ":IncRename " .. vim.fn.expand("<cword>")
  --       end,
  --       desc = "Incremental rename",
  --       mode = "n",
  --       noremap = true,
  --       expr = true,
  --     },
  --   },
  --   config = true,
  -- },


  -- init.lua:
  -- -------------------------------------------------
  -- finder (telescope)
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
    },
    keys = {
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    }
  },
  -- -------------------------------------------------
  -- finder (telescope)
  -- -------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      picker = {}
    },
    keys = {
      -- vim.keymap.set('n', '<leader>ff', '<cmd>lua Snacks.dashboard.pick("files")<CR>', { desc = '[F]ind [F]iles' })
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
        -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    }
  },

  -- {
  --   'nvim-telescope/telescope.nvim', tag = '0.1.8',
  --   lazy = false,
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   -- Add configuration here
  --   --
  --   config = function()
  --     local builtin = require('telescope.builtin')
  --     vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
  --     vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
  --     vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
  --     vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
  --   end,
  -- },
  -- -------------------------------------------------
  -- Highlight colors
  -- -------------------------------------------------
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },


  -- -------------------------------------------------
  -- treesitter
  -- for hightlighting
  -- -------------------------------------------------
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "bash",
  --       "html",
  --       "javascript",
  --       "json",
  --       "lua",
  --       "java",
  --       "markdown",
  --       "markdown_inline",
  --       "python",
  --       "query",
  --       "regex",
  --       "tsx",
  --       "typescript",
  --       "vim",
  --       "yaml",
  --       "go",
  --       "sql",
  --       "xml",
  --     },
  --   },
  -- },
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
            ensure_installed = {"vim", "vimdoc", "lua", "java", "javascript", "typescript", "html", "css", "json", "tsx", "markdown", "markdown_inline", "gitignore"},
            -- make sure highlighting it anabled
            highlight = {enable = true},
            -- enable tsx auto closing tag creation
            autotag = {
                enable = true
            }
        })
    end
  },


  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- if you'd rather extend the default config, use the code below instead:
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     -- add tsx and treesitter
  --     vim.list_extend(opts.ensure_installed, {
  --       "tsx",
  --       "typescript",
  --     })
  --   end,
  -- },

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
        signs = true, -- show icons in the signs column
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
  -- neo tree
  -- -------------------------------------------------
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   config = function()
  --       vim.keymap.set('n', '<leader>e', "<cmd>NvimTreeToggle<CR>", {desc = "Toggle [E]xplorer"})
  --       require("nvim-tree").setup({
  --           hijack_netrw = true,
  --           auto_reload_on_write = true,
  --       })
  --   end
  -- },
  -- -------------------------------------------------
  -- neo tree
  -- -------------------------------------------------
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v3.x",
  --   lazy = false,
  --   -----Instead of using `config`, you can use `opts` instead, if you'd like:
  --   -----@module "neo-tree"
  --   -----@type neotree.Config
  --   --opts = {},
  --   config = function()
  --     require("neo-tree").setup({
  --       filesystem = {
  --         follow_current_file = {
  --           enabled = true,
  --         },
  --         -- follow_current_file = true, -- Add this line to follow the current file
  --         filtered_items = {
  --           visible = false, -- when true, they will just be displayed differently than normal items
  --           hide_dotfiles = false,
  --           hide_gitignored = false,
  --           hide_hidden = false, -- only works on Windows for hidden files/directories
  --           -- hide_by_name = {
  --           --   --"node_modules"
  --           -- },
  --           -- hide_by_pattern = { -- uses glob style patterns
  --           --   --"*.meta",
  --           --   --"*/src/*/tsconfig.json",
  --           -- },
  --           -- always_show = { -- remains visible even if other settings would normally hide it
  --           --   --".gitignored",
  --           -- },
  --           -- always_show_by_pattern = { -- uses glob style patterns
  --           --   --".env*",
  --           -- },
  --           -- never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
  --           --   --".DS_Store",
  --           --   --"thumbs.db"
  --           -- },
  --           -- never_show_by_pattern = { -- uses glob style patterns
  --           --   --".null-ls_*",
  --           -- },
  --         },
  --       },
  --     })
  --     vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
  --   end,
  -- },
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
        vim.keymap.set("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", {desc = "Harpoon Mark File"})
        -- Set a vim motion to the tab key to open the harpoon menu to easily navigate frequented files
        vim.keymap.set("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", {desc = "Harpoon Toggle Menu"})
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

	--  {
	--    "nvim-lualine/lualine.nvim",
	--    -- lazy = false,
	-- dependencies = {
	--        "nvim-tree/nvim-web-devicons",
	--        lazy = false,
	-- },
	-- config = function()
	-- 	-- Make sure web devicons is loaded
	-- 	-- require("nvim-web-devicons").setup({})
	-- 	-- call the setup function with properties to define how our lualine will look
	-- 	require("lualine").setup({
	-- 		options = {
	-- 			-- Use web devicons if you have a nerdfont installed
	-- 			icons_enabled = true,
	-- 			-- Set the theme to dracula, lualine documentation has other themes available as well
	-- 			theme = "dracula",
	-- 			-- Separate components of lua line with chevrons
	-- 			component_separators = { left = "", right = "" },
	-- 			-- Separate sections with solid triangles
	-- 			section_separators = { left = "", right = "" },
	-- 			-- disable the status line and winbar
	-- 			disabled_filetypes = {
	-- 				statusline = {},
	-- 				winbar = {},
	-- 			},
	-- 			-- Don't focus lualine on NvimTree
	-- 			ignore_focus = { "NvimTree" },
	-- 			-- Always divide lualine in the middle
	-- 			always_divide_middle = true,
	-- 			-- Disable global status
	-- 			globalstatus = false,
	-- 			-- Refresh every 1000 miliseconds
	-- 			refresh = {
	-- 				statusline = 1000,
	-- 				tabline = 1000,
	-- 				winbar = 1000,
	-- 			},
	-- 		},
	-- 		-- Setup what each lualine section will contain
	-- 		-- sections start at a on the left and go to z on the right
	-- 		sections = {
	-- 			-- display the current mode in section a
	-- 			lualine_a = { "mode" },
	-- 			-- display the current git branch, git differences, and any code diagnostics in section b
	-- 			lualine_b = { "branch", "diff", "diagnostics" },
	-- 			-- display the filename in section c
	-- 			lualine_c = { "filename" },
	-- 			-- display the file encoding type, os, and filetype in section x
	-- 			lualine_x = { "encoding", "fileformat", "filetype" },
	-- 			-- display where you are at in the file in section y
	-- 			lualine_y = { "progress" },
	-- 			-- display exact location of the cursor in section z
	-- 			lualine_z = { "location" },
	-- 		},
	-- 		-- Setup what each section will contain in inactive buffers
	-- 		inactive_sections = {
	-- 			-- display nothing in sections a and b
	-- 			lualine_a = {},
	-- 			lualine_b = {},
	-- 			-- display the file name in section c
	-- 			lualine_c = { "filename" },
	-- 			-- display the exact location of the cursor in section x
	-- 			lualine_x = { "location" },
	-- 			-- display nothing in sections y and z
	-- 			lualine_y = {},
	-- 			lualine_z = {},
	-- 		},
	-- 		-- Use default values for tabline, winbar, inactive winbar and extensions
	-- 		tabline = {},
	-- 		winbar = {},
	-- 		inactive_winbar = {},
	-- 		extensions = {},
	-- 	})
	-- end,
	--  }

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
            vim.keymap.set({"n","v"}, "<leader>cf", vim.lsp.buf.format, { desc = "[C]ode [F]ormat" })
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
            require'nvim-autopairs'.setup({
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
    }

}
