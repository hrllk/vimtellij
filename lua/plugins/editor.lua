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
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- Add configuration here
    --
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    end,
  },

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
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    -----Instead of using `config`, you can use `opts` instead, if you'd like:
    -----@module "neo-tree"
    -----@type neotree.Config
    --opts = {},
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          -- follow_current_file = true, -- Add this line to follow the current file
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            -- hide_by_name = {
            --   --"node_modules"
            -- },
            -- hide_by_pattern = { -- uses glob style patterns
            --   --"*.meta",
            --   --"*/src/*/tsconfig.json",
            -- },
            -- always_show = { -- remains visible even if other settings would normally hide it
            --   --".gitignored",
            -- },
            -- always_show_by_pattern = { -- uses glob style patterns
            --   --".env*",
            -- },
            -- never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --   --".DS_Store",
            --   --"thumbs.db"
            -- },
            -- never_show_by_pattern = { -- uses glob style patterns
            --   --".null-ls_*",
            -- },
          },
        },
      })
      vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
    end,
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
    "thePrimeagen/harpoon",
    enabled = true,
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
        },
      })

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      vim.keymap.set("n", "<C-e>", function()
        print("Attempting to toggle harpoon quick menu")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- vim.keymap.set("n", "<C-h>", function()
      --   harpoon:list():select(1)
      -- end)
      -- vim.keymap.set("n", "<C-t>", function()
      --   harpoon:list():select(2)
      -- end)
      -- vim.keymap.set("n", "<C-n>", function()
      --   harpoon:list():select(3)
      -- end)
      -- vim.keymap.set("n", "<C-s>", function()
      --   harpoon:list():select(4)
      -- end)

      -- vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      -- -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      --
      -- vim.keymap.set("n", "<C-y>", function()
      --   harpoon:list():select(1)
      -- end)
      -- vim.keymap.set("n", "<C-i>", function()
      --   harpoon:list():select(2)
      -- end)
      -- vim.keymap.set("n", "<C-n>", function()
      --   harpoon:list():select(3)
      -- end)
      -- vim.keymap.set("n", "<C-s>", function()
      --   harpoon:list():select(4)
      -- end)
      --
      -- vim.keymap.set("n", "<C-S-P>", function()
      --   harpoon:list():prev()
      -- end)
      -- vim.keymap.set("n", "<C-S-N>", function()
      --   harpoon:list():next()
      -- end)
    end,
  },

  -- -------------------------------------------------
  -- Git Sign
  -- -------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    -- event = "LazyFile",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map("n", "<leader>gd", gs.diffthis,  "Diff this")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
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
}
