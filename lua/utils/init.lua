local M = {}

M.root_patterns = { ".git", "lua" }

local function default_on_open(term)
  vim.cmd "startinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

function M.open_term(cmd, opts)
  opts = opts or {}
  opts.size = opts.size or vim.o.columns * 0.5
  opts.direction = opts.direction or "float"
  opts.on_open = opts.on_open or default_on_open
  opts.on_exit = opts.on_exit or nil
  opts.dir = opts.dir or "git_dir"

  local Terminal = require("toggleterm.terminal").Terminal
  local new_term = Terminal:new {
    cmd = cmd,
    dir = opts.dir,
    auto_scroll = false,
    close_on_exit = false,
    on_open = opts.on_open,
    on_exit = opts.on_exit,
  }
  new_term:open(opts.size, opts.direction)
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "qa!"
      end
    end)
  else
    vim.cmd "qa!"
  end
end

function M.fg(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

function M.bg(group, color)
  vim.cmd("hi " .. group .. " guibg=" .. color)
end

function M.fg_bg(group, fg_color, bg_color)
  vim.cmd("hi " .. group .. " guifg=" .. fg_color .. " guibg=" .. bg_color)
end

function M.find_files()
  local opts = {}
  local telescope = require "telescope.builtin"

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

function M.reload_module(name)
  require("plenary.reload").reload_module(name)
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require "telescope.actions.state"
          local line = action_state.get_current_line()
          M.telescope(params.builtin, vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line }))()
        end)
        return true
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

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
