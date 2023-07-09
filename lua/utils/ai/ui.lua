local Layout = require "nui.layout"
local Popup = require "nui.popup"
local event = require("nui.utils.autocmd").event

local M = {}

-- Module functions
M.output_popup = nil
M.input_popup = nil
M.layout = nil
M.ai = nil
M.ai_type = "chat"

---@param prompt string
M.submit_prompt = function(prompt) end

M.clear_input = function()
  if M.input_popup ~= nil then
    local buffer = M.input_popup.bufnr
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {})
  end
end

M.get_component_heights = function(output_height_percentage)
  local lines_height = vim.api.nvim_get_option "lines"
  local statusline_height = vim.o.laststatus == 0 and 0 or 1 -- height of the statusline if present
  local cmdline_height = vim.o.cmdheight -- height of the cmdline if present
  local tabline_height = vim.o.showtabline == 0 and 0 or 1 -- height of the tabline if present
  local total_height = lines_height
  local used_height = statusline_height + cmdline_height + tabline_height
  local layout_height = total_height - used_height
  local output_height = math.floor(layout_height * output_height_percentage / 100)
  local prompt_height = layout_height - output_height
  local starting_row = tabline_height == 0 and 0 or 1

  return {
    starting_row = starting_row,
    layout = layout_height,
    output = output_height,
    prompt = prompt_height,
  }
end

M.is_focused = function()
  if M.input_popup == nil then
    vim.notify("GUI needs to be open", vim.log.levels.ERROR)
    return
  end
  local win = vim.api.nvim_get_current_win()
  return win == M.output_popup.winid or win == M.input_popup.winid
end

M.focus = function()
  if M.input_popup == nil then
    vim.notify("GUI needs to be open", vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_set_current_win(M.input_popup.winid)
end

M.create_ui = function(ai, ai_type)
  -- Destroy UI if already open
  if M.is_open() then
    return
  end

  M.output_popup = Popup {
    enter = false,
    focusable = true,
    zindex = 50,
    position = "50%",
    border = {
      style = "rounded",
      text = {
        top = " " .. "Alpha2Phi - AI Coder" .. " ",
        top_align = "center",
      },
    },
    buf_options = {
      filetype = "alpha2phi-ai-output",
    },
    win_options = {
      wrap = true,
    },
  }

  M.input_popup = Popup {
    enter = true,
    focusable = true,
    zindex = 50,
    position = "50%",
    border = {
      style = "rounded",
      padding = {
        left = 1,
        right = 1,
      },
      text = {
        top = " " .. "Prompt" .. " ",
        top_align = "center",
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
      filetype = "alpha2phi-ai-input",
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      wrap = true,
    },
  }

  local component_heights = M.get_component_heights(80)
  M.layout = Layout(
    {
      relative = "editor",
      position = {
        row = component_heights.starting_row,
        col = "100%",
      },
      size = {
        width = 30 .. "%",
        height = component_heights.layout,
      },
    },
    Layout.Box({
      Layout.Box(M.output_popup, { size = component_heights.output }),
      Layout.Box(M.input_popup, { size = component_heights.prompt }),
    }, { dir = "col" })
  )
  M.layout:mount()

  M.output_popup:on({ event.BufDelete, event.WinClosed }, function()
    M.destroy_ui()
  end)
  M.input_popup:on({ event.BufDelete, event.WinClosed }, function()
    M.destroy_ui()
  end)

  M.ai = ai
  if ai_type ~= nil then
    M.ai_type = ai_type
  end

  local input_buffer = M.input_popup.bufnr
  local output_buffer = M.output_popup.bufnr

  M.submit_prompt = function()
    local lines = vim.api.nvim_buf_get_lines(input_buffer, 0, -1, false)
    local prompt = table.concat(lines, "\n")
    M.send_prompt(prompt)
    M.clear_input()
  end

  local opts = { noremap = true, silent = true }
  if string.lower "<Enter>" == "<enter>" then
    vim.api.nvim_buf_set_keymap(input_buffer, "i", "<C-Enter>", "<Enter>", opts)
  end
  vim.api.nvim_buf_set_keymap(input_buffer, "i", "<Enter>", "<cmd>lua require('utils.ai.ui').submit_prompt()<cr>", opts)

  local key = "<C-k>"
  if key ~= nil then
    local keys = {}
    if type(key) == "table" then
      keys = key
    else
      keys = { key }
    end
    for _, k in ipairs(keys) do
      vim.api.nvim_buf_set_keymap(input_buffer, "n", k, "<cmd>lua vim.api.nvim_set_current_win(require('utils.ai.ui').output_popup.winid)<cr>", opts)
    end
  end
  key = "<C-j>"
  if key ~= nil then
    local keys = {}
    if type(key) == "table" then
      keys = key
    else
      keys = { key }
    end
    for _, k in ipairs(keys) do
      vim.api.nvim_buf_set_keymap(output_buffer, "n", k, "<cmd>lua vim.api.nvim_set_current_win(require('utils.ai.ui').input_popup.winid)<cr>", opts)
    end
  end

  M.set_destroy_key_mappings(input_buffer)
end

M.set_destroy_key_mappings = function(input_buffer)
  local mappings = {
    "<Esc>",
    "<C-c>",
  }
  for _, key in ipairs(mappings) do
    vim.api.nvim_buf_set_keymap(input_buffer, "n", key, "<cmd>lua require('utils.ai.ui').destroy_ui()<cr>", { noremap = true, silent = true })
  end
end

M.send_prompt = function(prompt)
  local output = ""
  if M.ai_type == "chat" then
    output = M.ai.chat(prompt)
  else
    output = M.ai.completion(prompt)
  end
  M.append_to_output("\n\n" .. output, 0)
end

M.destroy_ui = function()
  if M.layout ~= nil then
    M.layout:unmount()
  end
  M.layout = nil
  M.submit_prompt = function()
    -- Empty function
  end
end

M.is_open = function()
  return M.layout ~= nil
end

---Append text to the output, GPT should populate this
---@param txt string The text to append to the UI
---@param type integer 0/nil = normal, 1 = input
M.append_to_output = function(txt, type)
  local lines = vim.split(txt, "\n", {})

  local ns = vim.api.nvim_get_namespaces().alpha2phi_ai_output

  if ns == nil then
    ns = vim.api.nvim_create_namespace "alpha2phi_ai_output"
  end

  local hl = "Normal"
  if type == 1 then
    hl = "ErrorMsg"
  end

  local length = #lines

  if M.output_popup == nil then
    vim.notify("AI window needs to be open", vim.log.levels.ERROR)
    return
  end
  local buffer = M.output_popup.bufnr
  local win = M.output_popup.winid

  for i, line in ipairs(lines) do
    local currentLine = vim.api.nvim_buf_get_lines(buffer, -2, -1, false)[1]
    vim.api.nvim_buf_set_lines(buffer, -2, -1, false, { currentLine .. line })

    -- local last_line_num = vim.api.nvim_buf_line_count(buffer)
    -- local last_line = vim.api.nvim_buf_get_lines(buffer, last_line_num - 1, last_line_num, false)[1]
    -- local new_text = last_line .. line

    -- vim.api.nvim_buf_set_lines(buffer, last_line_num - 1, last_line_num, false, { new_text })
    local last_line_num = vim.api.nvim_buf_line_count(buffer)
    -- vim.api.nvim_buf_add_highlight(buffer, ns, hl, last_line_num - 1, 0, -1)

    if i < length then
      -- Add new line
      vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { "" })
    end
    vim.api.nvim_win_set_cursor(win, { last_line_num, 0 })
  end
end

return M
