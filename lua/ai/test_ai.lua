local function InvokePythonAPI()
  local output = vim.api.nvim_call_function("OpenAIGPTCompletion", { "Write a Python hello world program" })
  vim.print(output)
end

local function InvokeLuaAPI()
  local ai = require "ai.openai_api"
  local result = ai.chat "How is the weather today"
  vim.print(result)
end

local function Chat_UI()
  local ai = require "ai"
  ai.toggle(true, "chat", "Hello how are you")
end

local function Completion_UI()
  local ai = require "ai"
  ai.toggle(true, "completion", "Hello how are you")
end

InvokePythonAPI()

-- Completion_UI()
-- ChatUI()
