------------------------------
-- theme override (background)
------------------------------

local visual_group = vim.api.nvim_create_augroup("UserVisualHighlight", { clear = true })

local function apply_visual_highlights()
  local visual_background = "#264F78"

  vim.api.nvim_set_hl(0, "Visual", { bg = visual_background })
  vim.api.nvim_set_hl(0, "VisualNOS", { bg = visual_background })
end

apply_visual_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = visual_group,
  callback = apply_visual_highlights,
})
