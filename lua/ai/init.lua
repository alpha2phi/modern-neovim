local ui = require "ai.ui"

local M = {}

function M.toggle(toggle, prompt)
  local open = (toggle ~= "" and toggle) or (toggle == "" and not ui.is_open())
  if open then
    -- Open
    ui.create_ui()
    if prompt ~= nil then
      ui.send_prompt(prompt)
    end
    return true
  else
    -- Close
    ui.destroy_ui()
    return false
  end
end
