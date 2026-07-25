------------------------------
-- markdown rendering
-- render Markdown syntax and code blocks in the editor
------------------------------
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      html = {
        comment = {
          conceal = false,
        },
      },
    },
  },
}
