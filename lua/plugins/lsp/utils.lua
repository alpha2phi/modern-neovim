local M = {}

local FORMATTING = require("null-ls").methods.FORMATTING
local DIAGNOSTICS = require("null-ls").methods.DIAGNOSTICS
local COMPLETION = require("null-ls").methods.COMPLETION
local CODE_ACTION = require("null-ls").methods.CODE_ACTION
local HOVER = require("null-ls").methods.HOVER

local function list_registered_providers_names(ft)
  local s = require "null-ls.sources"
  local available_sources = s.get_available(ft)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.list_formatters(ft)
  local providers = list_registered_providers_names(ft)
  return providers[FORMATTING] or {}
end

function M.list_linters(ft)
  local providers = list_registered_providers_names(ft)
  return providers[DIAGNOSTICS] or {}
end

function M.list_completions(ft)
  local providers = list_registered_providers_names(ft)
  return providers[COMPLETION] or {}
end

function M.list_code_actions(ft)
  local providers = list_registered_providers_names(ft)
  return providers[CODE_ACTION] or {}
end

function M.list_hovers(ft)
  local providers = list_registered_providers_names(ft)
  return providers[HOVER] or {}
end

return M
