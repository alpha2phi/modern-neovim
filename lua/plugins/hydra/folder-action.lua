local M = {}

local uv = vim.uv
local is_windows = uv.os_uname().version:match "Windows"
local path_separator = is_windows and "\\" or "/"

local function remove_path_last_separator(path)
  if not path then
    return ""
  end
  if path:sub(#path) == path_separator then
    return path:sub(1, #path - 1)
  end
  return path
end

local function project_files(opts)
  local action_state = require "telescope.actions.state"
  local make_entry = require "telescope.make_entry"
  local strings = require "plenary.strings"
  local utils = require "telescope.utils"
  local entry_display = require "telescope.pickers.entry_display"
  local devicons = require "nvim-web-devicons"
  local def_icon = devicons.get_icon("fname", { default = true })
  local iconwidth = strings.strdisplaywidth(def_icon)

  local map_i_actions = function(_, map)
    map("i", "<C-o>", function(prompt_bufnr)
      require("userlib.telescope.picker_keymaps").open_selected_in_window(prompt_bufnr)
    end, { noremap = true, silent = true })
    map("i", "<C-g>", function(prompt_bufnr)
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local finder = current_picker.finder
      finder.path = vim.cfg.runtime__starts_cwd
      finder.cwd = finder.path
      current_picker:refresh(finder, {
        reset_prompt = true,
        multi = current_picker._multi,
      })
    end, {
      desc = "Go to home dir",
    })
  end

  opts = opts or {}
  if not opts.cwd then
    opts.cwd = vim.uv.cwd()
  end
  opts.hidden = true

  local nicely_cwd = require("userlib.runtime.path").home_to_tilde(opts.cwd)
  opts.prompt_title = opts.prompt_title or nicely_cwd

  opts.attach_mappings = function(_, map)
    map_i_actions(_, map)
    return true
  end

  local entry_make = make_entry.gen_from_file(opts)
  opts.entry_maker = function(line)
    local entry = entry_make(line)
    local displayer = entry_display.create {
      separator = " ",
      items = {
        { width = iconwidth },
        { width = nil },
        { remaining = true },
      },
    }
    entry.display = function(et)
      local tail_raw, path_to_display = M.get_path_and_tail(et.value)
      local tail = tail_raw .. " "
      local icon, iconhl = utils.get_devicons(tail_raw)

      return displayer {
        { icon, iconhl },
        tail,
        { path_to_display, "TelescopeResultsComment" },
      }
    end
    return entry
  end

  if opts and opts.oldfiles then
    opts.results_title = " Recent files:"
    opts.include_current_session = true
    if opts.cwd then
      opts.cwd_only = false
    end
    require("telescope.builtin").oldfiles(opts)
    return
  end
end

M.folder_action = function(cwd, buffer, pre_hook)
  local ok, Hydra = pcall(require, "hydra")
  if not ok then
    return
  end
  cwd = remove_path_last_separator(cwd)

  local _ = function(callback)
    return function()
      if pre_hook then
        pre_hook()
      else
        vim.cmd "wincmd w"
      end
      vim.schedule(callback)
    end
  end

  local hydra = Hydra {
    name = "",
    mode = { "n", "i" },
    config = {
      buffer = buffer,
    },
    heads = {
      {
        "f",
        _(function()
          project_files {
            cwd = cwd,
            use_all_files = true,
          }
        end),
        {
          private = true,
          exit = true,
          desc = "T.Files",
        },
      },
      {
        "p",
        _(function()
          require("telescope").extensions.file_browser.file_browser {
            files = false,
            use_fd = true,
            cwd = cwd,
            respect_gitignore = true,
          }
        end),
        {
          private = true,
          desc = "Folders",
          exit = true,
        },
      },
      {
        "s",
        _(function()
          require "userlib.telescope.live_grep_call" {
            cwd = cwd,
          }
        end),
        {
          desc = "Content",
          private = true,
          exit = true,
        },
      },
      {
        "r",
        _(function()
          require("userlib.telescope.pickers").project_files {
            oldfiles = true,
            cwd_only = false,
            cwd = cwd,
          }
        end),
        {
          private = true,
          desc = "Recent",
          exit = true,
        },
      },
      {
        "w",
        _(function()
          require("userlib.runtime.utils").change_cwd(cwd, "tcd")
          vim.schedule(function()
            au.exec_useraucmd(au.user_autocmds.DoEnterDashboard)
          end)
        end),
        {
          private = true,
          desc = "Cwd",
          exit = true,
        },
      },
      {
        "<CR>",
        _(function()
          -- require('userlib.runtime.utils').change_cwd(cwd, 'tcd')
          require("oil").open(cwd)
          -- require('mini.files').open(cwd)
        end),
        {
          private = true,
          desc = "Browser",
          exit = true,
        },
      },
      {
        "t",
        _(function()
          vim.cmd("tabfind " .. cwd)
        end),
        {
          private = true,
          desc = "Open in tab",
          exit = true,
        },
      },
    },
  }

  hydra:activate()
end

M.folder_action("~/workspace/platform/alphalib", 0)

return M
