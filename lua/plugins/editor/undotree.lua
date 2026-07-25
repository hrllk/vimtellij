------------------------------
-- undo tree
-- browse and restore the buffer's undo history
------------------------------
return {
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
}
