local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local lang = ""
local file_type = ""

local function default_on_open(term)
  vim.cmd "stopinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

local function cht_on_open(term)
  vim.cmd "stopinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_name(term.bufnr, "cheatsheet-" .. term.bufnr)
  vim.api.nvim_buf_set_option(term.bufnr, "filetype", "cheat")
  vim.api.nvim_buf_set_option(term.bufnr, "syntax", lang)
end

local function cht_on_exit(_)
  vim.cmd [[normal gg]]
end

function M.open_term(cmd, opts)
  opts = opts or {}
  opts.size = opts.size or vim.o.columns * 0.5
  opts.direction = opts.direction or "float"
  opts.on_open = opts.on_open or default_on_open
  opts.on_exit = opts.on_exit or nil

  local new_term = Terminal:new {
    cmd = cmd,
    dir = "git_dir",
    auto_scroll = false,
    close_on_exit = false,
    start_in_insert = false,
    on_open = opts.on_open,
    on_exit = opts.on_exit,
  }
  new_term:open(opts.size, opts.direction)
end

function M.cht()
  local buf = vim.api.nvim_get_current_buf()
  lang = ""
  file_type = vim.api.nvim_buf_get_option(buf, "filetype")
  vim.ui.input({ prompt = "cht.sh input: ", default = file_type .. " " }, function(input)
    local cmd = ""
    if input == "" or not input then
      return
    elseif input == "h" then
      cmd = ""
    else
      local search = ""
      local delimiter = " "
      for w in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        if lang == "" then
          lang = w
        else
          if search == "" then
            search = w
          else
            search = search .. "+" .. w
          end
        end
      end
      cmd = lang
      if search ~= "" then
        cmd = cmd .. "/" .. search
      end
    end
    cmd = "curl cht.sh/" .. cmd
    M.open_term(cmd, { direction = "vertical", on_open = cht_on_open, on_exit = cht_on_exit })
  end)
end

function M.stack_overflow()
  local buf = vim.api.nvim_get_current_buf()
  file_type = vim.api.nvim_buf_get_option(buf, "filetype")
  vim.ui.input({ prompt = "so input: ", default = file_type .. " " }, function(input)
    local cmd = ""
    if input == "" or not input then
      return
    elseif input == "h" then
      cmd = "-h"
    else
      cmd = input
    end
    cmd = "so " .. cmd
    M.open_term(cmd, { direction = "float" })
  end)
end

function M.reddit()
  local buf = vim.api.nvim_get_current_buf()
  local cmd = "tuir"
  M.open_term(cmd, { direction = "float" })
end

return M
