local M = {}

function M.git_diff_picker(opts)
  opts = opts or require("telescope.themes").get_dropdown {}
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  list = vim.fn.systemlist "git diff --name-only"

  pickers
    .new(opts, {
      prompt_title = "Git Diff Files",
      finder = finders.new_table { results = list },
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return M
