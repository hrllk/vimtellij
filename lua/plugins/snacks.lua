return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "amansingh-afk/milli.nvim" },
    init = function()
      vim.g.snacks_animate = false

      local function apply_picker_highlights()
        local none = "NONE"
        vim.api.nvim_set_hl(0, "SnacksNormal", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksWinSeparator", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPicker", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerList", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = "#0F766E", bg = none })
        vim.api.nvim_set_hl(0, "SnacksPickerTitle", { bg = none })
      end

      apply_picker_highlights()
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = apply_picker_highlights,
      })
    end,
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      {
        "<leader>gg",
        function()
          local root = Snacks.git.get_root() or vim.uv.cwd()
          Snacks.lazygit({ cwd = root })
        end,
        desc = "Lazygit",
      },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    },
    opts = function()
      local splash = require("milli").load({ splash = "ididnot" })
      return {
        image = {},
        explorer = {},
        lazygit = {
          configure = true,
          win = {
            style = "lazygit",
            wo = {
              number = false,
              relativenumber = false,
              signcolumn = "no",
              cursorline = false,
              foldcolumn = "0",
            },
          },
        },
        picker = {
          hidden = true,
          ignored = true,
          sources = {
            files = {
              hidden = true,
              ignored = true,
              exclude = { "*.class", "*.class.uniqueId*", "*.jar", "*.war", "*.log", "*.min.js", "*.map" },
            },
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
                    local width = picker.resolved_layout.layout.width == 0.5 and 40 or 0.5
                    picker:set_layout(Snacks.picker.config.layout({
                      source = "explorer",
                      layout = { preset = "sidebar", preview = false, layout = { width = width, min_width = 40 } },
                    }))
                    picker.list.win:focus()
                    require("config.snacks_dashboard").refresh()
                  end,
                },
              },
              win = { list = { keys = { ["D"] = "diff_files", ["="] = "explorer_toggle_width" } } },
            },
            grep = {
              hidden = true,
              ignored = true,
              exclude = { "*.class", "*.class.uniqueId*", "*.jar", "*.war", "*.log", "*.min.js", "*.map" },
            },
          },
        },
        dashboard = {
          enabled = true,
          preset = {
            header = table.concat(splash.frames[1], "\n"),
            keys = {
              { action = ":lua Snacks.dashboard.pick('files')", key = "f", text = { { " ", hl = "SnacksDashboardIcon" }, { "Find File", hl = "SnacksDashboardDesc", width = 50 }, { "f", hl = "SnacksDashboardKey" } } },
              { action = ":lua Snacks.dashboard.pick('oldfiles')", key = "r", text = { { " ", hl = "SnacksDashboardIcon" }, { "Recent Files", hl = "SnacksDashboardDesc", width = 50 }, { "r", hl = "SnacksDashboardKey" } } },
              { action = ":Lazy", key = "L", enabled = package.loaded.lazy ~= nil, text = { { "󰒲 ", hl = "SnacksDashboardIcon" }, { "Lazy", hl = "SnacksDashboardDesc", width = 50 }, { "L", hl = "SnacksDashboardKey" } } },
              { action = ":qa", key = "q", text = { { " ", hl = "SnacksDashboardIcon" }, { "Quit", hl = "SnacksDashboardDesc", width = 50 }, { "q", hl = "SnacksDashboardKey" } } },
            },
          },
          sections = {
            { section = "header", padding = 1 },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("snacks").setup(opts)
      require("config.snacks_dashboard").setup({ splash = "ididnot" })
    end,
  },
}
