return {
  {
    "kdheepak/lazygit.nvim",
    lazy = false,

    -- enabled = false,
    config = function()
        vim.keymap.set('n', ';c', function() require("lazygit").lazygit() end, { desc = 'LazyGit' })
    end
  },
}
