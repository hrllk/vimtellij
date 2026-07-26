local colors = require("config.colors")

local M = {}

local milli_runtime = require("milli.runtime")
local namespace = vim.api.nvim_create_namespace("milli_dashboard_splash")

local state = {}
local hl_cache = {}
local splash_opts = { splash = "ididnot", loop = true }
local setup_done = false

local function get_hl(fg_hex, bg_hex)
  local key = fg_hex .. "_" .. bg_hex
  if hl_cache[key] then
    return hl_cache[key]
  end

  local bg_suffix = bg_hex == "NONE" and "NONE" or bg_hex:sub(2)
  local name = "MilliSplash_" .. fg_hex:sub(2) .. "_" .. bg_suffix
  local spec = { fg = fg_hex }
  if bg_hex ~= "NONE" then
    spec.bg = bg_hex
  end
  vim.api.nvim_set_hl(0, name, spec)
  hl_cache[key] = name
  return name
end

local function apply_highlights()
  local accent = "#A1A1AA"
  vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { fg = accent, bg = colors.none })
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = accent, bg = colors.none })
  vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = accent, bg = colors.none })
  vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = accent, bg = colors.none })
  vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = accent, bg = colors.none, bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = accent, bg = colors.none })
  vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = accent, bg = colors.none })
  vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = accent, bg = colors.none })
end

local function rtrim(s)
  return (s:gsub("%s+$", ""))
end

local function anchor_in_frame0(data)
  local first = data.frames and data.frames[1]
  if not first then
    return nil, nil
  end

  for i, line in ipairs(first) do
    if line:find("[^%s]") then
      return i, line
    end
  end

  return nil, nil
end

local function open_dashboard_buffers()
  local bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "snacks_dashboard" then
      bufs[#bufs + 1] = buf
    end
  end
  return bufs
end

local function paint_dashboard_splash(buf, token, data, start_row, pad)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local pad_bytes = #pad
  local function paint(idx)
    if not vim.api.nvim_buf_is_valid(buf) then
      return false
    end

    local current = state[buf]
    if not current or current.token ~= token then
      return false
    end

    local frame = data.frames[idx + 1]
    local colors = data.colors and data.colors[idx + 1]
    if not frame then
      return false
    end

    local padded = {}
    for i, line in ipairs(frame) do
      padded[i] = pad .. line
    end

    vim.bo[buf].modifiable = true
    pcall(vim.api.nvim_buf_set_lines, buf, start_row, start_row + #padded, false, padded)
    vim.bo[buf].modified = false
    vim.bo[buf].modifiable = false

    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
    if not colors then
      return true
    end

    for row_i, row_runs in ipairs(colors) do
      local buf_row = start_row + row_i - 1
      for _, run in ipairs(row_runs) do
        local sb, eb, fg, bg = run[1], run[2], run[3], run[4]
        local hl = get_hl(fg, bg)
        pcall(vim.api.nvim_buf_set_extmark, buf, namespace, buf_row, pad_bytes + sb, {
          end_col = pad_bytes + eb,
          hl_group = hl,
          priority = 200,
        })
      end
    end

    return true
  end

  paint(0)

  local idx = 1
  local function step()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local current = state[buf]
    if not current or current.token ~= token then
      return
    end

    if idx >= #data.frames and not splash_opts.loop then
      return
    end

    local fi = idx % #data.frames
    paint(fi)
    idx = idx + 1

    local delay = data.delays[fi + 1] or 100
    vim.defer_fn(step, delay)
  end

  vim.defer_fn(step, data.delays[1] or 100)
end

local function attach_buffer(buf)
  local current = state[buf] or { token = 0 }
  state[buf] = current
  current.token = current.token + 1
  local token = current.token

  local ok, data = pcall(milli_runtime.load, splash_opts)
  if not ok or not data or not data.frames then
    return
  end

  local anchor_idx, anchor_line = anchor_in_frame0(data)
  if not anchor_idx then
    return
  end

  local anchor_trim = rtrim(anchor_line)
  vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

  local function locate()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, line in ipairs(lines) do
      local pos = line:find(anchor_trim, 1, true)
      if pos then
        return i - anchor_idx, line:sub(1, pos - 1)
      end
    end
    return nil, nil
  end

  local function start(attempt)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if not state[buf] or state[buf].token ~= token then
      return
    end

    local start_row, pad = locate()
    if not start_row then
      if attempt < 20 then
        vim.defer_fn(function()
          start(attempt + 1)
        end, 25)
      end
      return
    end

    paint_dashboard_splash(buf, token, data, start_row, pad)
  end

  start(0)

  if not current.attached then
    current.attached = true
    vim.api.nvim_buf_attach(buf, false, {
      on_detach = function()
        state[buf] = nil
      end,
    })
  end
end

function M.refresh()
  for _, buf in ipairs(open_dashboard_buffers()) do
    attach_buffer(buf)
  end
end

function M.setup(opts)
  if setup_done then
    if opts then
      splash_opts = vim.tbl_deep_extend("force", splash_opts, opts)
      splash_opts.loop = true
    end
    return
  end

  setup_done = true
  if opts then
    splash_opts = vim.tbl_deep_extend("force", splash_opts, opts)
  end
  splash_opts.loop = true

  apply_highlights()

  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    callback = apply_highlights,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = {
      "SnacksDashboardOpened",
      "SnacksDashboardUpdatePost",
    },
    callback = function()
      vim.schedule(M.refresh)
    end,
  })
end

return M
