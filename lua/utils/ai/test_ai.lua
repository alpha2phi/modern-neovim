local function InvokePythonAPI()
  local output = vim.api.nvim_call_function("OpenAIGPTCompletion", { "Write a Python hello world program" })
  vim.print(output)
end

local function InvokeLuaAPI()
  local ai = require "utils.ai.openai_api"
  local result = ai.chat "Write a hello world program in Rust"
  vim.print(result)
end

local function Chat_UI()
  local ai = require "utils.ai"
  ai.toggle(true, "chat", "Write a HTTP server in Node.js")
end

local function Completion_UI()
  local ai = require "utils.ai"
  ai.toggle(true, "completion", "Write a HTTP server in Go language")
end

-- InvokePythonAPI()

-- InvokeLuaAPI()

Completion_UI()

-- Chat_UI()
