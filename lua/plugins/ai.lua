return {


  -- -------------------------------------------------
  -- avante
  -- -------------------------------------------------
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {

      -- auto_suggestions_provider = "gemini",
      -- provider = "gemini",
      -- providers = {
      --   gemini = {
      --     -- endpoint = "https://generativelanguage.googleapis.com/v1beta/",
      --     -- endpoint = "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions",
      --     model = "models/gemini-2.5-flash-preview-04-17",
      --     -- model = "gemini-2.5-flash-preview-04-17",
      --     api_key_name = 'GEMINI_API_KEY',
      --     extra_request_body = {
      --
      --       temperature = 0.75,
      --       max_tokens = 8192,
      --
      --     },
      --   },
      -- },
      --
      provider = "gemini",
      gemini = {
        model = "gemini-2.5-flash-preview-05-20",   -- your desired model (or use gpt-4o, etc.)
        timeout = 30000,                            -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_tokens = 8192,                          -- Increase this to include reasoning tokens (for reasoning models)
        api_key_name = "GEMINI_API_KEY",
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },

      -- provider = 'gemini',
      -- providers = {
      --
      --     gemini = {
      --       endpoint = 'https://generativelanguage.googleapis.com/v1beta/',
      --       model = 'models/gemini-2.5-flash-preview-04-17',
      --       -- model = 'gemini-2.5-flash-preview-04-17',
      --       timeout = 30000,
      --       api_key_name = 'GEMINI_API_KEY',
      --       -- endpoint = 'https://generativelanguage.googleapis.com/v1beta/',
      --       -- model = 'models/gemini-2.0-flash',
      --
      --       extra_request_body = {
      --
      --           temperature = 0,
      --           max_tokens = 12288,
      --
      --       }
      --     },
      -- },

      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = 'co',
          theirs = 'ct',
          all_theirs = 'ca',
          both = 'cb',
          cursor = 'cc',
          next = ']x',
          prev = '[x',
        },
        suggestion = {
          accept = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
        jump = {
          next = ']]',
          prev = '[[',
        },
        submit = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        sidebar = {
          switch_windows = '<Tab>',
          reverse_switch_windows = '<S-Tab>',
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type 'right' | 'left' | 'top' | 'bottom'
        position = 'right', -- the position of the sidebar
        wrap = true,        -- similar to vim.o.wrap
        width = 40,         -- default % based on available width
        sidebar_header = {
          align = 'center', -- left, center, right for title
          rounded = true,
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = 'DiffText',
          incoming = 'DiffAdd',
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = 'copen',
      },

    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua',      -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
