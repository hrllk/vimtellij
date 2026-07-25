return {
  {
    "hrllk/showkeys",
    name = "showkeys.nvim",
    lazy = false,
    cmd = { "ShowkeysStart", "ShowkeysStop", "ShowkeysToggle" },
    config = function(_, opts)
      require("showkeys").setup(opts)
    end,
    opts = {
      auto_start = true,
      startup_user_events = { "ToggleMyPrompt" },
      maxkeys = 3,
      show_count = false,
      separator = " → ",
      timeout_ms = 1200,
      winopts = {
        focusable = false,
        relative = "editor",
        style = "minimal",
        border = "none",
        height = 1,
        row = 1,
        col = 0,
        zindex = 200,
      },
    },
  },
}
