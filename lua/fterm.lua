-- fterm.nvim - floating terminal

local FTERM_WIN="fterm_win"
local FTERM_BUF="fterm_buf"
local FTERM_WIDTH="fterm_width"
local FTERM_HEIGHT="fterm_height"
local FTERM_POSITION="fterm_position"

local FTERM_DEFAULS={
  position="right",
  width=80,
  height=20
}

local function get_option(name)
  return vim.g[string.format("fterm_%s", name)] or FTERM_DEFAULS[name]
end

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

  local position = get_option("position")
  local row
  local col
  local width
  local height
  local cmdheight = vim.api.nvim_get_option("cmdheight")
  
  if position == "top" then
    row = 0
    col = 0
    width = editor_width
    height = get_option("height")
  elseif position == "bottom" then
    col = 0
    height = get_option("height")
    row = editor_height - height - cmdheight - 2
    width = editor_width
  elseif  position == "left" then
    row = 0
    col = 0
    width = get_option("width")
    height = editor_height - 2 - cmdheight
  else
    row = 0
    width = get_option("width")
    col = editor_width - width
    height = editor_height - 2 - cmdheight
  end

  local buf = vim.g[FTERM_BUF]
  print(row, col, width, height)
  win = vim.api.nvim_open_win(buf, true, {
    relative='win', anchor='NW', row=row, col=col, width=width, height=height, style="minimal"
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

local function exec(cmd)
  if not window_opened() then
    open_window()
  end

  local buf = vim.g[FTERM_BUF]
  local channel = vim.api.nvim_buf_get_option(buf, "channel")
  vim.call("chansend", channel, string.format("%s\n", cmd))
end

local function add_vim_commands()
  vim.cmd("command! FTermToggle lua require'fterm'.toggle()")
  vim.cmd("command! -nargs=1 FTermExec lua require'fterm'.exec(<args>)")
end

local function config(opts)
  if opts["position"] then
    vim.g[FTERM_POSITION] = opts["position"]
  end

  if opts["width"] then
    vim.g[FTERM_WIDTH] = opts["width"]
  end

  if opts["height"] then
    vim.g[FTERM_HEIGHT] = opts["height"]
  end

  if opts["commands"] then
    add_vim_commands()
  end
end

return {
  config = config,
  exec = exec,
  toggle = toggle,
}
