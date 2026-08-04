------------------------------
-- explorer options
-- configure the Snacks file explorer and its explorer source
------------------------------

local explorer_width_states = setmetatable({}, { __mode = "k" })
local explorer_widths = { 0.3, 0.4, 0.5 }

return {
  explorer = {},
  picker = {
    sources = {
      explorer = {
        hidden = true,
        ignored = true,
        exclude = { ".DS_Store", "*.jar", "*.war", "*.log", "*.min.js", "*.map" },
        actions = {
          diff_files = {
            action = function(picker)
              local sel = picker:selected()
              if #sel ~= 2 then
                Snacks.notify.warn("Diff할 파일 2개를 <Tab>으로 선택하세요")
                return
              end

              local file1, file2 = sel[1].file, sel[2].file
              if not file1 or not file2 then
                Snacks.notify.warn("파일 항목만 diff할 수 있습니다")
                return
              end

              picker:close()
              vim.cmd("tabnew " .. vim.fn.fnameescape(file1))
              vim.cmd("vert diffsplit " .. vim.fn.fnameescape(file2))
            end,
          },
          explorer_toggle_width = {
            action = function(picker)
              local state = explorer_width_states[picker]
              if not state then
                state = {
                  default_width = picker.resolved_layout.layout.width,
                  step = 0,
                }
                explorer_width_states[picker] = state
              end

              state.step = state.step + 1

              local width = explorer_widths[state.step]
              if not width then
                width = state.default_width
                explorer_width_states[picker] = nil
              end

              picker:set_layout(Snacks.picker.config.layout({
                source = "explorer",
                layout = { preset = "sidebar", preview = false, layout = { width = width, min_width = 40 } },
              }))
              picker.list.win:focus()
              require("config.snacks_dashboard").refresh()
            end,
          },
        },
        win = {
          list = {
            keys = {
              ["D"] = "diff_files",
              ["="] = "explorer_toggle_width",
            },
          },
        },
      },
    },
  },
}
