local M = {}

local servers = {
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = {
          command = "cargo clippy",
          extraArgs = { "--no-deps" },
        },
      },
    },
  },
  sumneko_lua = {
    settings = {
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
    },
  },
  tsserver = {
    disable_formatting = false,
  },
  dockerls = {},
}

local lsp_utils = require("plugins.lsp.utils")

local function lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function M.setup(_)
  lsp_utils.on_attach(function(client, buffer)
    require("plugins.lsp.format").on_attach(client, buffer)
    require("plugins.lsp.keymaps").on_attach(client, buffer)
  end)

  require("mason-lspconfig").setup { ensure_installed = vim.tbl_keys(servers) }
  require("mason-lspconfig").setup_handlers {
    function(server)
      local opts = servers[server] or {}
      opts.capabilities = lsp_capabilities()
      require("lspconfig")[server].setup(opts)
    end,
    ["rust_analyzer"] = function(server)
      local rt = require "rust-tools"
      local opts = servers[server] or {}
      opts.capabilities = lsp_capabilities()
      rt.setup { server = opts }
    end,
  }
end

return M
