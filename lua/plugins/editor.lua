return {
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
    init = function()
      vim.g.snacks_animate = false

      local function apply_picker_highlights()
        local none = "NONE"

        vim.api.nvim_set_hl(0, "SnacksNormal", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksWinSeparator", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPicker", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerList", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerTitle", { bg = none })
      end

      apply_picker_highlights()

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = function()
          apply_picker_highlights()
        end,
      })
    end,
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
    lazy = false,
    dependencies = {
      -- ts-autotag utilizes treesitter to understand the code structure to automatically close tsx tags
      "windwp/nvim-ts-autotag"
    },
    -- when the plugin builds run the TSUpdate command to ensure all our servers are installed and updated
    build = ':TSUpdate',
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")
      local languages = {
        "vim",
        "vimdoc",
        "lua",
        "java",
        "kotlin",
        "go",
        "gomod",
        "javascript",
        "typescript",
        "html",
        "css",
        "json",
        "tsx",
        "markdown",
        "markdown_inline",
        "gitignore",
        "sql",
        "http",
        "nginx",
        "xml",
      }

      treesitter.setup(opts)
      treesitter.install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        pattern = languages,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
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
    opts = {
      html = {
        comment = {
          conceal = false,
        },
      },
    },
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

  {
    'nvim-lualine/lualine.nvim',
    event = "UIEnter",
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
      "nvim-lua/plenary.nvim",
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
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },

  -- -------------------------------------------------
  -- fold preview / folding
  -- -------------------------------------------------
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldmethod = "manual"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.opt.viewoptions:append("folds")
      vim.opt.sessionoptions:append("folds")
      vim.opt.viewdir = vim.fn.stdpath("state") .. "/manual-fold-views//"
    end,
    config = function()
      local function fold_virt_text_handler(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local suffixWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - suffixWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)

          if targetWidth > curWidth + chunkWidth then
            newVirtText[#newVirtText + 1] = chunk
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            newVirtText[#newVirtText + 1] = { chunkText, chunk[2] }

            local truncatedWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + truncatedWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - truncatedWidth)
            end
            break
          end

          curWidth = curWidth + chunkWidth
        end

        newVirtText[#newVirtText + 1] = { suffix, "MoreMsg" }
        return newVirtText
      end

      local function apply_fold_highlights()
        local none = "NONE"

        vim.api.nvim_set_hl(0, "Folded", { bg = none })
        vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = none })
        vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { bg = none })
        vim.api.nvim_set_hl(0, "UfoPreviewCursorLine", { bg = none })
        vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { bg = none })
      end

      local function sync_cursorline_for_fold()
        if vim.bo.buftype ~= "" then
          return
        end

        local folded = vim.fn.foldclosed(vim.fn.line(".")) ~= -1
        vim.wo.cursorline = not folded
      end

      local ufo = require("ufo")
      ufo.setup({
        provider_selector = function()
          return ""
        end,
        fold_virt_text_handler = fold_virt_text_handler,
      })

      apply_fold_highlights()
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = function()
          apply_fold_highlights()
          sync_cursorline_for_fold()
        end,
      })

      vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "CursorMovedI", "WinEnter", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("UfoCursorLineSync", { clear = true }),
        callback = sync_cursorline_for_fold,
      })

      vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
      vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })

      local fold_group = vim.api.nvim_create_augroup("UfoFoldPersistence", { clear = true })

      local function should_persist(bufnr)
        return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
      end

      vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
        group = fold_group,
        callback = function(event)
          if not should_persist(event.buf) then
            return
          end

          pcall(vim.cmd, "silent! mkview")
        end,
      })

      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        group = fold_group,
        callback = function(event)
          if not should_persist(event.buf) then
            return
          end

          pcall(vim.cmd, "silent! loadview")
        end,
      })

      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if should_persist(bufnr) then
          vim.api.nvim_win_call(winid, function()
            pcall(vim.cmd, "silent! loadview")
          end)
        end
      end

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("UfoAutoPreview", { clear = true }),
        callback = function()
          if vim.fn.foldclosed(vim.fn.line(".")) == -1 then
            return
          end

          local ok, ufo_mod = pcall(require, "ufo")
          if not ok then
            return
          end

          ufo_mod.peekFoldedLinesUnderCursor()
        end,
      })
    end,
  }
}
