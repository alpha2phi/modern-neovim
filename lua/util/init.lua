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

return M
