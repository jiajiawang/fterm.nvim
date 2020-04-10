-- fterm.nvim - floating terminal

local FTERM_WIN="fterm_win"
local FTERM_BUF="fterm_buf"

local function window_opened()
  local win = vim.g[FTERM_WIN]
  return win and vim.api.nvim_win_is_valid(win)
end

local function close_window()
  local win = vim.g[FTERM_WIN]
  vim.api.nvim_win_close(win, false)
  vim.g[FTERM_WIN] = -1
end

local function buf_exists()
  local buf = vim.g[FTERM_BUF]
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function create_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.g[FTERM_BUF] = buf
end

local function open_window()
  if not buf_exists() then
    create_buf()
  end

  local editor_width = vim.api.nvim_get_option("columns")
  local editor_height = vim.api.nvim_get_option("lines")
  local width = 100
  local height = editor_height - 4
  local row = editor_width - width
  local col = editor_width - 80
  local buf = vim.g[FTERM_BUF]
  win = vim.api.nvim_open_win(buf, true, {
    relative='win', anchor='NW', row=0, col=col, width=width, height=height, style="minimal"
  })

  local buf_name = vim.api.nvim_buf_get_name(buf)

  if not string.match(buf_name, "^term:") then
    vim.api.nvim_command("terminal")
  end

  vim.g[FTERM_WIN] = win
end

local function toggle()
  if window_opened() then
    close_window()
    return
  end

  open_window()
end

return {
  toggle = toggle,
}
