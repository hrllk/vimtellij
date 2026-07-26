------------------------------
-- notifications
-- display styled notification popups
------------------------------
local colors = require("config.colors")

return {
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      background_color = colors.terminal,
      render = "wrapped-compact",
    },
  },
}
