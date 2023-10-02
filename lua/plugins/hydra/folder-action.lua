local M = {}

local utils = require "utils"

M.open = function(cwd, buffer, pre_hook)
  local ok, Hydra = pcall(require, "hydra")
  if not ok then
    return
  end
  cwd = utils.remove_path_last_separator(cwd)

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

return M
