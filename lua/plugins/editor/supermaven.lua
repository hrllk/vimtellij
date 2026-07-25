------------------------------
-- AI completion
-- provide inline code suggestions while typing
------------------------------
return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
