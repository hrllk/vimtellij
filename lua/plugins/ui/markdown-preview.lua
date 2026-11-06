------------------------------
-- Markdown preview
-- preview Markdown documents in a browser
------------------------------
local function refresh_markdown_preview_mermaid(plugin_dir)
  local target = plugin_dir .. "/app/_static/mermaid.min.js"
  local mermaid_url = "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"

  if vim.g.__markdown_preview_mermaid_patched then
    return
  end

  if vim.fn.executable("curl") == 1 then
    vim.fn.system({ "curl", "-fsSL", mermaid_url, "-o", target })
  elseif vim.fn.executable("wget") == 1 then
    vim.fn.system({ "wget", "-qO", target, mermaid_url })
  end

  vim.g.__markdown_preview_mermaid_patched = true
end

return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function(plugin)
      local plugin_dir = (plugin and plugin.dir) or (vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim")
      vim.fn.system({ "sh", "-c", "cd " .. vim.fn.shellescape(plugin_dir .. "/app") .. " && yarn install" })
      refresh_markdown_preview_mermaid(plugin_dir)
    end,
    config = function(plugin)
      local plugin_dir = (plugin and plugin.dir) or (vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim")
      refresh_markdown_preview_mermaid(plugin_dir)
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- The plugin only sets its defaults when this variable is unset, so a
      -- partial table would drop the rest; keep the stock values and turn off
      -- only the browser following the nvim cursor.
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 1,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }

      -- The preview re-reads g:mkdp_preview_options on every refresh, so
      -- flipping it here takes effect in an already open browser tab. vim.g
      -- returns a copy, so the whole table has to be assigned back.
      vim.api.nvim_create_user_command("MarkdownPreviewSyncScrollToggle", function()
        local opts = vim.g.mkdp_preview_options
        opts.disable_sync_scroll = opts.disable_sync_scroll == 1 and 0 or 1
        vim.g.mkdp_preview_options = opts
        vim.notify("Markdown preview sync scroll: " .. (opts.disable_sync_scroll == 1 and "off" or "on"))
      end, { desc = "Toggle browser following the cursor in markdown preview" })
      vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewSyncScrollToggle<cr>", {
        desc = "Toggle markdown preview sync scroll",
      })
    end,
    ft = { "markdown" },
  },
}
