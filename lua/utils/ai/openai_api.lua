local M = {}

local Job = require "plenary.job"

local OPENAI_COMPLETION_URL = "https://api.openai.com/v1/completions"
local OPENAI_COMPLETION_MODEL = "text-davinci-003"
local OPENAI_CHAT_URL = "https://api.openai.com/v1/chat/completions"
local OPENAI_CHAT_MODEL = "gpt-3.5-turbo"
local TEMPERATURE = 1
local TOP_P = 1
local MAX_TOKENS = 2048

local function get_api_key()
  return vim.env.OPENAI_API_KEY
end

local function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function get_prompt()
  local prompt = nil
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]
  if start_row ~= end_row or start_col ~= end_col then
    prompt = vim.fn.getline(start_row, end_row)
    prompt = trim(table.concat(prompt, "\n"))
    vim.fn.setpos("'<", { 0, 0, 0, 0 })
    vim.fn.setpos("'>", { 0, 0, 0, 0 })
  end
  return prompt
end

local function http_request(url, request)
  local api_key = get_api_key()
  if api_key == nil then
    vim.notify "OpenAI API key not found"
    return nil
  end
  local body = vim.fn.json_encode(request)
  local job = Job:new {
    command = "curl",
    args = {
      url,
      "-H",
      "Content-Type: application/json",
      "-H",
      string.format("Authorization: Bearer %s", api_key),
      "-d",
      body,
    },
  }
  local is_completed = pcall(job.sync, job, 10000)
  if is_completed then
    local result = job:result()
    local ok, parsed = pcall(vim.json.decode, table.concat(result, ""))
    if not ok then
      vim.notify "Failed to parse OpenAI result"
      return nil
    end
    return parsed
  end
  return nil
end

function M.chat(input)
  local prompt = get_prompt() or input or ""
  local request = {}
  request["model"] = OPENAI_CHAT_MODEL
  request["temperature"] = TEMPERATURE
  request["top_p"] = TOP_P
  msgs = {}
  msg = {}
  msg["role"] = "user"
  msg["content"] = prompt
  table.insert(msgs, msg)
  request["messages"] = msgs

  local result = http_request(OPENAI_CHAT_URL, request)
  local text = ""
  if result ~= nil and result["choices"] ~= nil then
    text = result["choices"][1]["message"]["content"]
  end
  return text
end

function M.completion(input)
  local prompt = get_prompt() or input or ""

  local request = {}
  request["model"] = OPENAI_COMPLETION_MODEL
  request["max_tokens"] = MAX_TOKENS
  request["temperature"] = TEMPERATURE
  request["top_p"] = TOP_P
  request["prompt"] = prompt

  local result = http_request(OPENAI_COMPLETION_URL, request)
  local text = ""
  if result ~= nil and result["choices"] ~= nil then
    text = result["choices"][1]["text"]
  end
  return text
end

return M
