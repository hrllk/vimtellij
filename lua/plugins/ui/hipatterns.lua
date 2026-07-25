------------------------------
-- inline highlights
-- highlight colors and patterns directly in buffers
------------------------------
return {
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
}
