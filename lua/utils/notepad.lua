local M = {}

--[[ launch_notepad()
-- Launch a small, transparent floating window with a scartch buffer that persists until Neovim closes
--
-- @requires M.notepad_loaded, M.notepad_buf, M.notepad_win variables in util (this) module
--]]
M.notepad_loaded = false
M.notepad_buf, M.notepad_win = nil, nil

function M.launch_notepad()
  if not M.notepad_loaded or not vim.api.nvim_win_is_valid(M.notepad_win) then
    if not M.notepad_buf or not vim.api.nvim_buf_is_valid(M.notepad_buf) then
      -- Create a buffer if it none existed
      M.notepad_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(M.notepad_buf, "bufhidden", "hide")
      vim.api.nvim_buf_set_option(M.notepad_buf, "filetype", "markdown")
      vim.api.nvim_buf_set_lines(M.notepad_buf, 0, 1, false, {
        "# Notepad",
        "",
        "> Notepad clears when the current Neovim session closes",
      })
    end
    -- Create a window
    M.notepad_win = vim.api.nvim_open_win(M.notepad_buf, true, {
      border = "rounded",
      relative = "editor",
      style = "minimal",
      height = math.ceil(vim.o.lines * 0.5),
      width = math.ceil(vim.o.columns * 0.5),
      row = 1, --> Top of the window
      col = math.ceil(vim.o.columns * 0.5), --> Far right; should add up to 1 with win_width
    })
    vim.api.nvim_win_set_option(M.notepad_win, "winblend", 30) --> Semi transparent buffer

    -- Keymaps
    local keymaps_opts = { silent = true, buffer = M.notepad_buf }
    vim.keymap.set("n", "<ESC>", function()
      M.launch_notepad()
    end, keymaps_opts)
    vim.keymap.set("n", "q", function()
      M.launch_notepad()
    end, keymaps_opts)
  else
    vim.api.nvim_win_hide(M.notepad_win)
  end
  M.notepad_loaded = not M.notepad_loaded
end

return M
