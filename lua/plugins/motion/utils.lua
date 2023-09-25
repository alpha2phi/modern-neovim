local M = {}
local fmt = string.format
local find_string = require("utils").find_string

function M.get_available_stacks(notify)
  local available_stacks = require("trailblazer.trails").stacks.get_sorted_stack_names()
  if notify then
    vim.notify(fmt("Available stacks: %s", table.concat(available_stacks, ", ")), "info", { title = "TrailBlazer" })
  end
  return available_stacks
end

function M.add_trail_mark_stack()
  vim.ui.input({ prompt = "stack name: " }, function(name)
    if not name then
      return
    end
    local available_stacks = M.get_available_stacks()
    if find_string(available_stacks, name) then
      vim.notify(fmt('"%s" stack already exists.', name), "warn", { title = "TrailBlazer" })
      return
    end
    local tb = require "trailblazer"
    tb.add_trail_mark_stack(name)
    vim.notify(fmt('"%s" stack created.', name), "info", { title = "TrailBlazer" })
  end)
end

function M.delete_trail_mark_stack()
  vim.ui.input({ prompt = "stack name: " }, function(name)
    if not name then
      return
    end
    local available_stacks = M.get_available_stacks()
    if not find_string(available_stacks, name) then
      vim.notify(fmt('"%s" stack does not exist.', name), "warn", { title = "TrailBlazer" })
      return
    end
    local tb = require "trailblazer"
    tb.delete_trail_mark_stack(name)
    vim.notify(fmt('"%s" stack deleted.', name), "info", { title = "TrailBlazer" })
  end)
end

return M
