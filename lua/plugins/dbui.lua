------------------------------
-- database UI
-- browse databases and execute SQL with vim-dadbod-ui
------------------------------
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 40

      local group = vim.api.nvim_create_augroup("DadbodUIKeymaps", { clear = true })
      local function setup_window_keymaps(buf)
        local filetype = vim.bo[buf].filetype
        local is_dbui_buffer = filetype == "dbui" or filetype == "dbout"
          or (filetype == "sql" and vim.b[buf].dbui_db_key_name ~= nil)
        if not is_dbui_buffer then
          return
        end

        local function resize_window(amount)
          local win = vim.fn.bufwinid(buf)
          if win == -1 then
            return
          end

          if filetype == "dbui" then
            local width = vim.api.nvim_win_get_width(win)
            local max_width = math.max(20, vim.o.columns - 20)
            vim.api.nvim_win_set_width(win, math.min(max_width, math.max(20, width + amount)))
          else
            local height = vim.api.nvim_win_get_height(win)
            local max_height = math.max(5, vim.o.lines - vim.o.cmdheight - 2)
            vim.api.nvim_win_set_height(win, math.min(max_height, math.max(5, height + amount)))
          end
        end

        vim.keymap.set("n", "-", function() resize_window(-5) end, {
          buffer = buf,
          silent = true,
          desc = "Decrease DBUI window",
        })
        vim.keymap.set("n", "=", function() resize_window(5) end, {
          buffer = buf,
          silent = true,
          desc = "Increase DBUI window",
        })
      end

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "DBUIOpened",
        callback = function()
          setup_window_keymaps(vim.api.nvim_get_current_buf())
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "dbui", "dbout", "sql" },
        callback = function(args)
          setup_window_keymaps(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "*",
        callback = function(args)
          setup_window_keymaps(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "dbout",
        callback = function(args)
          vim.schedule(function()
            local win = vim.fn.bufwinid(args.buf)
            if win == -1 then
              return
            end

            local available_height = vim.o.lines - vim.o.cmdheight - 2
            vim.api.nvim_win_set_height(win, math.max(5, math.floor(available_height * 0.5)))
          end)
        end,
      })
    end,
    keys = {
      { "<leader>db", function() require("config.dbui").toggle_tab() end, desc = "Database UI (own tab)" },
      { "<leader>dB", "<Cmd>DBUIToggle<CR>", desc = "Database UI (drawer here)" },
    },
  },
}
