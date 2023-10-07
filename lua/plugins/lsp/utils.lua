local M = {}

local loaded = false
local FORMATTING = nil
local DIAGNOSTICS = nil
local COMPLETION = nil
local CODE_ACTION = nil
local HOVER = nil

local function init()
  local nls_methods = require("null-ls").methods
  FORMATTING = nls_methods.FORMATTING
  DIAGNOSTICS = nls_methods.DIAGNOSTICS
  COMPLETION = nls_methods.COMPLETION
  CODE_ACTION = nls_methods.CODE_ACTION
  HOVER = nls_methods.HOVER
  loaded = true
end

local function list_registered_providers_names(ft)
  if not loaded then
    init()
  end
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

function M.capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

local diagnostics_active = false

function M.show_diagnostics()
  return diagnostics_active
end

function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

return M
