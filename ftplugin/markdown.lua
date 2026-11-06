-- Pretty print a selected JSON fence body with jq.
-- Markdown has no formatprg of its own, so gq inside a ```json fence falls back
-- to Vim's text wrapping; run the selection through jq explicitly instead.
vim.keymap.set("v", "<leader>jq", ":!jq .<cr>", {
  buffer = true,
  desc = "Pretty print JSON block",
})

-- gd: open the file a [text](target) link points at, then fall back to LSP.
-- marksman resolves only paths relative to the file or the workspace root: it
-- reads a leading "/" as workspace-root-relative, ignores "~", and indexes
-- only .md files. So links like [x](/Users/...), [x](~/...) or [x](a.html)
-- returned no definition. Resolve those on the filesystem first; headings,
-- wiki links and anything not found on disk still go to marksman.
local external_exts = {
  html = true, htm = true, pdf = true, png = true, jpg = true, jpeg = true,
  gif = true, svg = true, webp = true, xlsx = true, docx = true, pptx = true,
}

local function link_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local init = 1
  while true do
    local s, e, target = line:find("%[[^%]]*%]%(([^)]+)%)", init)
    if not s then
      return nil
    end
    if col >= s and col <= e then
      return target
    end
    init = e + 1
  end
end

local function resolve(target)
  target = vim.trim(target)
  target = target:gsub("^<(.*)>$", "%1"):gsub("^'(.*)'$", "%1"):gsub('^"(.*)"$', "%1")
  local path, anchor = target:match("^([^#]*)#?(.*)$")
  if path == "" then
    return nil
  end
  path = path:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
  path = vim.fn.expand(path)

  local candidates = {}
  if path:sub(1, 1) == "/" then
    table.insert(candidates, path)
  end
  table.insert(candidates, vim.fn.expand("%:p:h") .. "/" .. path)
  local client = vim.lsp.get_clients({ bufnr = 0, name = "marksman" })[1]
  local root = (client and client.root_dir) or vim.fs.root(0, ".git")
  if root then
    table.insert(candidates, root .. "/" .. path:gsub("^/", ""))
  end

  for _, p in ipairs(candidates) do
    p = vim.fs.normalize(p)
    if vim.uv.fs_stat(p) then
      return p, anchor
    end
  end
end

vim.keymap.set("n", "gd", function()
  local target = link_under_cursor()
  if target and target:match("^%a[%w+.-]*://") then
    vim.ui.open(target)
    return
  end
  local path, anchor = nil, nil
  if target then
    path, anchor = resolve(target)
  end
  if not path then
    vim.lsp.buf.definition()
    return
  end

  local ext = (path:match("%.([^./]+)$") or ""):lower()
  if external_exts[ext] then
    vim.ui.open(path)
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
  if anchor and anchor ~= "" then
    local pat = "\\c^#\\+\\s\\+" .. vim.fn.escape(anchor, "\\/.*$^~[]"):gsub("%-", "[- ]")
    vim.fn.search(pat, "cw")
  end
end, { buffer = true, desc = "Follow markdown link / LSP definition" })
