------------------------------
-- database UI placement
-- DBUI opens its drawer in whatever tab you are standing in, which crowds it
-- in next to the windows you were already working in. Give it a tab of its
-- own instead: the editing layout is left untouched and the drawer gets the
-- full height, with a scratch window beside it for queries and results.
------------------------------

local M = {}

-- Where <leader>db was pressed from, so a second press goes back there.
local origin_tab = nil

local function find_dbui_window()
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dbui" then
        return tab, win
      end
    end
  end
  return nil, nil
end

local function return_to_origin()
  if origin_tab and vim.api.nvim_tabpage_is_valid(origin_tab) then
    vim.api.nvim_set_current_tabpage(origin_tab)
  else
    -- The tab we came from is gone; any other tab beats staying put.
    pcall(vim.cmd, "tabprevious")
  end
end

---Open DBUI in a dedicated tab, or step in and out of the one already open.
function M.toggle_tab()
  local tab, win = find_dbui_window()

  if not tab then
    origin_tab = vim.api.nvim_get_current_tabpage()
    vim.cmd("tabnew")
    vim.cmd("DBUI")
    return
  end

  if vim.api.nvim_get_current_tabpage() == tab then
    return_to_origin()
    return
  end

  origin_tab = vim.api.nvim_get_current_tabpage()
  vim.api.nvim_set_current_tabpage(tab)
  pcall(vim.api.nvim_set_current_win, win)
end

return M
