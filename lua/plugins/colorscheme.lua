return {
  --  {
  --    "LazyVim/LazyVim",
  --    opts = {
  --      colorscheme = "catppuccin",
  --    },
  --  },
  {

    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
}
