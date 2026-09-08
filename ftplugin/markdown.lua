-- Pretty print a selected JSON fence body with jq.
-- Markdown has no formatprg of its own, so gq inside a ```json fence falls back
-- to Vim's text wrapping; run the selection through jq explicitly instead.
vim.keymap.set("v", "<leader>jq", ":!jq .<cr>", {
  buffer = true,
  desc = "Pretty print JSON block",
})
