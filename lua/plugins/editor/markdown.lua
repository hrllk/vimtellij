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
      checkbox = {
        -- task 상태 표기. '[ ]'와 '[x]'는 markdown 문법이라 여기 없어도 동작한다.
        -- raw 는 소문자로 비교되며, 대괄호 뒤에 공백이 있어야 치환된다.
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          waiting = { raw = "[>]", rendered = "󰦖 ", highlight = "DiagnosticWarn" },
          progress = { raw = "[/]", rendered = "󰦕 ", highlight = "DiagnosticInfo" },
          blocked = { raw = "[!]", rendered = "󰗖 ", highlight = "DiagnosticError" },
          question = { raw = "[?]", rendered = "󰘥 ", highlight = "DiagnosticHint" },
          cancelled = {
            raw = "[~]",
            rendered = "󰅘 ",
            highlight = "Comment",
            scope_highlight = "Comment",
          },
        },
      },
    },
  },
}
