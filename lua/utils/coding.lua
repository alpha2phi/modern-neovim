local M = {}

local lang = ""
local file_type = ""
local utils = require "utils"

local function cht_on_open(term)
  vim.cmd "stopinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_name(term.bufnr, "cheatsheet-" .. term.bufnr)
  vim.api.nvim_set_option_value("filetype", "cheat", { buf = term.bufnr })
  vim.api.nvim_set_option_value("syntax", lang, { buf = term.bufnr })
end

local function cht_on_exit(_)
  vim.cmd [[normal gg]]
end

function M.cht()
  local buf = vim.api.nvim_get_current_buf()
  lang = ""
  file_type = vim.api.nvim_get_option_value("filetype", { buf = buf })
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
    utils.open_term(cmd, { direction = "vertical", on_open = cht_on_open, on_exit = cht_on_exit })
  end)
end

function M.stack_overflow()
  local buf = vim.api.nvim_get_current_buf()
  file_type = vim.api.nvim_get_option_value("filetype", { buf = buf })
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
    utils.open_term(cmd, { direction = "float" })
  end)
end

function M.reddit()
  local cmd = "tuir"
  utils.open_term(cmd, { direction = "float" })
end

function M.gh_dash()
  local cmd = "gh dash"
  utils.open_term(cmd, { direction = "float" })
end

return M
