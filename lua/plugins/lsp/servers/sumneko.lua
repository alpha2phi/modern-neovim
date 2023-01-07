local sumneko_lua = {}

function sumneko_lua.setup(config, on_attach)
  config.settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      hint = {
        enable = false,
      },
    },
  }

  config.on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
  end

  return config
end

return sumneko_lua
