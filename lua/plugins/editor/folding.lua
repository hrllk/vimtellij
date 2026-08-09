local colors = require("config.colors")

------------------------------
-- folding
-- preview and persist folded code sections
------------------------------
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    init = function()
      vim.opt.foldcolumn = "1"
      vim.opt.foldmethod = "manual"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.opt.viewoptions:append("folds")
      vim.opt.sessionoptions:append("folds")
      vim.opt.viewdir = vim.fn.stdpath("state") .. "/manual-fold-views//"
    end,
    config = function()
      local sidecar = require("config.folding_sidecar")

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
        for _, group in ipairs({
          "Folded",
          "UfoFoldedBg",
          "UfoPreviewWinBar",
          "UfoPreviewCursorLine",
          "UfoCursorFoldedLine",
        }) do
          vim.api.nvim_set_hl(0, group, { bg = colors.none })
        end
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
      local group = vim.api.nvim_create_augroup("UfoFolding", { clear = true })

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        group = group,
        callback = function()
          apply_fold_highlights()
          sync_cursorline_for_fold()
        end,
      })

      vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "CursorMovedI", "WinEnter", "InsertLeave" }, {
        group = group,
        callback = sync_cursorline_for_fold,
      })

      vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
      vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })

      local function should_persist(bufnr)
        return vim.bo[bufnr].buftype == ""
          and vim.api.nvim_buf_get_name(bufnr) ~= ""
          and not sidecar.is_markdown(bufnr)
      end

      local function save_view(event)
        if should_persist(event.buf) then
          pcall(vim.cmd, "silent! mkview")
        end
      end

      local function load_view(event)
        if should_persist(event.buf) then
          pcall(vim.cmd, "silent! loadview")
        end
      end

      vim.api.nvim_create_autocmd("BufWinLeave", {
        group = group,
        callback = save_view,
      })

      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = load_view,
      })

      local function restore_sidecar(event)
        if not sidecar.is_markdown(event.buf) then
          return
        end
        local path = sidecar.path(event.buf)
        if not path or vim.fn.filereadable(path) ~= 1 then
          return
        end

        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(event.buf) then
            return
          end

          vim.b[event.buf].fold_sidecar_restoring = true
          sidecar.restore(event.buf)
          vim.b[event.buf].fold_sidecar_restoring = false
        end)
      end

      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = restore_sidecar,
      })

      local key_state
      local key_namespace = vim.api.nvim_create_namespace("fold_sidecar")

      local function warn_write_failure(ok)
        if ok == false then
          vim.notify("Failed to save the Markdown fold sidecar.", vim.log.levels.WARN)
        end
      end

      local function persist_open(state)
        if not vim.api.nvim_buf_is_valid(state.buf)
          or not sidecar.is_markdown(state.buf)
          or vim.b[state.buf].fold_sidecar_restoring then
          return
        end

        vim.api.nvim_win_call(state.win, function()
          if state.fold_start ~= -1 then
            warn_write_failure(sidecar.remove_for_range(state.buf, state.fold_start, state.fold_end))
          end
        end)
      end

      vim.on_key(function(char)
        local mode = vim.fn.mode():sub(1, 1)
        if mode ~= "n" then
          key_state = nil
          return
        end

        if char == "z" then
          local line = vim.fn.line(".")
          local fold_start = vim.fn.foldclosed(line)
          key_state = {
            buf = vim.api.nvim_get_current_buf(),
            line = fold_start ~= -1 and fold_start or line,
            fold_start = fold_start,
            fold_end = fold_start ~= -1 and vim.fn.foldclosedend(line) or nil,
            win = vim.api.nvim_get_current_win(),
          }
          return
        end

        if not key_state then
          return
        end

        local state = key_state
        key_state = nil
        if char == "o" then
          vim.schedule(function()
            persist_open(state)
          end)
        end
      end, key_namespace)

      local function install_markdown_visual_fold(bufnr)
        if not sidecar.is_markdown(bufnr) then
          return
        end

        vim.keymap.set("x", "zf", function()
          local current_line = vim.fn.line(".")
          local visual_line = vim.fn.line("v")
          local start_line = math.min(current_line, visual_line)
          local end_line = math.max(current_line, visual_line)
          vim.cmd(("%d,%dfold"):format(start_line, end_line))

          if vim.fn.foldclosed(start_line) == start_line then
            warn_write_failure(sidecar.upsert(bufnr, start_line, end_line))
          end
        end, { buffer = bufnr, desc = "Create persistent Markdown fold" })
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "markdown",
        callback = function(event)
          install_markdown_visual_fold(event.buf)
        end,
      })

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        install_markdown_visual_fold(bufnr)
      end

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        callback = function()
          if vim.fn.foldclosed(vim.fn.line(".")) == -1 then
            return
          end

          local ok, ufo_mod = pcall(require, "ufo")
          if ok then
            ufo_mod.peekFoldedLinesUnderCursor()
          end
        end,
      })

      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        vim.api.nvim_win_call(winid, function()
          load_view({ buf = vim.api.nvim_win_get_buf(winid) })
        end)
      end
    end,
  },
}
