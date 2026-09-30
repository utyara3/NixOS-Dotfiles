local M = {}

local terminal_buf = nil
local terminal_win = nil
local terminal_job = nil

local function valid_buf(buf)
  return buf ~= nil and vim.api.nvim_buf_is_valid(buf)
end

local function valid_win(win)
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

local function terminal_height()
  return math.max(8, math.floor(vim.o.lines * 0.25))
end

local function open_window(buf)
  vim.cmd("botright split")

  terminal_win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_height(
    terminal_win,
    terminal_height()
  )

  vim.api.nvim_win_set_buf(
    terminal_win,
    buf
  )
end

local function create_terminal()
  terminal_buf = vim.api.nvim_create_buf(false, true)

  vim.bo[terminal_buf].buflisted = false
  vim.bo[terminal_buf].bufhidden = "hide"

  open_window(terminal_buf)

  terminal_job = vim.fn.jobstart(vim.o.shell, {
    term = true,
    cwd = vim.fn.getcwd(),

    on_exit = function()
      vim.schedule(function()
        terminal_job = nil
      end)
    end,
  })

  vim.api.nvim_set_current_win(terminal_win)
  vim.cmd("startinsert")
end

function M.open()
  if valid_win(terminal_win) then
    vim.api.nvim_set_current_win(terminal_win)
    vim.cmd("startinsert")
    return
  end

  if valid_buf(terminal_buf) and terminal_job then
    open_window(terminal_buf)

    vim.api.nvim_set_current_win(terminal_win)
    vim.cmd("startinsert")
    return
  end

  terminal_buf = nil
  terminal_job = nil

  create_terminal()
end

function M.toggle()
  if valid_win(terminal_win) then
    vim.api.nvim_win_close(terminal_win, true)
    terminal_win = nil
    return
  end

  M.open()
end

function M.run(command, cwd)
  M.open()

  if not terminal_job then
    return
  end

  local full_command = command

  if cwd then
    full_command = string.format(
      "cd -- %s && %s",
      vim.fn.shellescape(cwd),
      command
    )
  end

  vim.defer_fn(function()
    if not valid_buf(terminal_buf) or not terminal_job then
      return
    end

    vim.fn.chansend(
      terminal_job,
      full_command .. "\n"
    )

    vim.cmd("startinsert")
  end, 50)
end

return M
