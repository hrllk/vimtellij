return {
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
  },
}
