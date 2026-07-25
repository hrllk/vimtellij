------------------------------
-- LSP keymaps
-- configure navigation, diagnostics, actions, and formatting shortcuts
------------------------------
local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>O", ":lua vim.lsp.buf.code_action()<CR>")
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  vim.keymap.set("n", "K", function()
    local ok, ufo = pcall(require, "ufo")
    if ok then
      local winid = ufo.peekFoldedLinesUnderCursor()
      if winid then
        return
      end
    end

    vim.lsp.buf.hover()
  end, { desc = "Hover / fold preview" })
  vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  vim.keymap.set("n", "gr", function()
    Snacks.picker.lsp_references({
      include_declaration = true,
      include_current = true,
      layout = { preset = "select" },
    })
  end, { desc = "LSP References (Snacks Ivy)" })
  vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
  vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>")
end

return M
