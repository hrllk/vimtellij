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
    end,
    ft = { "markdown" },
  },
}
