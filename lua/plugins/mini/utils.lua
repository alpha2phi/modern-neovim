local M = {}

local show_dotfiles = true
local mf = require "mini.files"

function M.map_split(buf_id, lhs, direction)
  local rhs = function()
    local fsentry = mf.get_fs_entry()
    if fsentry.fs_type ~= "file" then
      return
    end
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(mf.get_target_window(), function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)

    mf.set_target_window(new_target_window)
    mf.go_in()
    mf.close()
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

local function filter_show(fs_entry)
  return true
end

local function filter_hide(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

function M.toggle_dotfiles()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  mf.refresh { content = { filter = new_filter } }
end

function M.get_current_dir()
  local fsentry = mf.get_fs_entry()
  if not fsentry then
    return nil
  end
  return vim.fs.dirname(fsentry.path)
end

function M.files_set_cwd(path)
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = mf.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end

function M.jump()
  require("flash").jump {
    search = {
      mode = "search",
      max_length = 0,
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "minifiles"
        end,
      },
    },
    label = { after = { 0, 0 } },
    pattern = "^",
  }
end

function M.file_actions(bufnr)
  local cwd = M.get_current_dir()
  require("plugins.hydra.file-action").open(cwd, bufnr, function()
    mf.close()
  end)
end

function M.folder_actions(bufnr)
  local fsentry = mf.get_fs_entry()
  if not fsentry then
    return nil
  end
  require("plugins.hydra.folder-action").open(fsentry.path, bufnr, function()
    mf.close()
  end)
end

return M
