local M = {}

function M.smart_quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "q!"
      end
    end)
  else
    vim.cmd "q!"
  end
end

function M.version()
  local v = vim.version()
  if v and not v.prerelease then
    vim.notify(("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch), vim.log.levels.WARN, { title = "Neovim: not running nightly!" })
  end
end

function M.is_win()
  if vim.loop.os_uname().version:match "Windows" then
    return true
  else
    return false
  end
end

function M.basename(str)
  return string.gsub(str, "(.*/)(.*)", "%2")
end

function M.join_paths(...)
  local path_sep = M.is_win() and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

local quote_pattern = "([" .. ("%^$().[]*+-?"):gsub("(.)", "%%%1") .. "])"
local function escape_text(str)
  return str:gsub(quote_pattern, "%%%1")
end

local BASE_LUA_PATH = M.join_paths(vim.fn.stdpath "config", "lua")

function M.glob_require(package)
  local glob_path = M.join_paths(BASE_LUA_PATH, package, "*.lua")

  for _, path in pairs(vim.split(vim.fn.glob(glob_path), "\n")) do
    local pkg = path:gsub(escape_text(BASE_LUA_PATH), ""):gsub(".lua", "")
    local basename = M.basename(pkg)
    if basename ~= "init" and basename:sub(1, 1) ~= "_" then
      require(pkg)
    end
  end
end

return M
