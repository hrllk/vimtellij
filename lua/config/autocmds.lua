------------------------------
-- auto format turn off
------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    vim.b.autoformat = false
  end,
})

------------------------------
-- calling automatically neovim starts
------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command("ShowkeysToggle") -- show key toggle
    vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" }) -- Trigger ToggleMyPrompt on VimEnter
  end,
})

------------------------------
-- visual mode style
------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Visual", { bg = "#264F78" })
    vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#264F78" })
  end,
})

------------------------------
-- auto save
------------------------------
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
  callback = function()
    -- Only auto save if the buffer is modified, has a file name, and is a normal file buffer
    if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= "" and vim.bo.buftype == "" and vim.bo.buflisted then
      vim.cmd("silent w")
    end
  end,
})

------------------------------
-- save/restore folds and cursor view
------------------------------
vim.opt.viewoptions:append("folds")

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = vim.api.nvim_create_augroup("PersistView", { clear = true }),
  callback = function()
    if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
      return
    end

    pcall(vim.cmd, "mkview")
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("PersistView", { clear = false }),
  callback = function()
    if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
      return
    end

    pcall(vim.cmd, "silent! loadview")
  end,
})
