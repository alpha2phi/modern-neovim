local M = {}

local pickers = require "telescope.pickers"
local Path = require "plenary.path"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local transform_mod = require("telescope.actions.mt").transform_mod
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local os_sep = Path.path.sep
local scan = require "plenary.scandir"

---Keep track of the active extension and folders for `live_grep`
local live_grep_filters = {
  ---@type nil|string
  extension = nil,
  ---@type nil|string[]
  directories = nil,
}

local function run_live_grep(current_input)
  require("telescope.builtin").live_grep {
    additional_args = live_grep_filters.extension and function()
      return { "-g", "*." .. live_grep_filters.extension }
    end,
    search_dirs = live_grep_filters.directories,
    -- default_text = current_input,
  }
end

function M.git_diff_picker(opts)
  opts = opts or require("telescope.themes").get_dropdown {}
  local list = vim.fn.systemlist "git diff --name-only"
  pickers.new(opts, { prompt_title = "Git Diff Files", finder = finders.new_table { results = list }, sorter = conf.generic_sorter(opts) }):find()
end

M.actions = transform_mod {

  set_extension = function(prompt_bufnr)
    local current_input = action_state.get_current_line()
    vim.ui.input({ prompt = "*." }, function(input)
      if input == nil then
        return
      end
      live_grep_filters.extension = input
      actions.close(prompt_bufnr)
      run_live_grep(current_input)
    end)
  end,

  set_folders = function(prompt_bufnr)
    local current_input = action_state.get_current_line()
    local data = {}
    scan.scan_dir(vim.loop.cwd(), {
      hidden = true,
      only_dirs = true,
      respect_gitignore = true,
      on_insert = function(entry)
        table.insert(data, entry .. os_sep)
      end,
    })
    table.insert(data, 1, "." .. os_sep)
    actions.close(prompt_bufnr)
    pickers
      .new({}, {
        prompt_title = "Folders for Live Grep",
        finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file {} },
        previewer = conf.file_previewer {},
        sorter = conf.file_sorter {},
        attach_mappings = function(bufnr)
          action_set.select:replace(function()
            local current_picker = action_state.get_current_picker(bufnr)

            local dirs = {}
            local selections = current_picker:get_multi_selection()
            if vim.tbl_isempty(selections) then
              table.insert(dirs, action_state.get_selected_entry().value)
            else
              for _, selection in ipairs(selections) do
                table.insert(dirs, selection.value)
              end
            end
            live_grep_filters.directories = dirs
            actions.close(bufnr)
            run_live_grep(current_input)
          end)
          return true
        end,
      })
      :find()
  end,
}

return M
