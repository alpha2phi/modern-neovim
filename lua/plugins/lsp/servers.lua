local M = {}

local lsp_utils = require "plugins.lsp.utils"

function M.setup(_, opts)
  lsp_utils.on_attach(function(client, buffer)
    require("plugins.lsp.format").on_attach(client, buffer)
    require("plugins.lsp.keymaps").on_attach(client, buffer)
  end)

  local servers = opts.servers
  require("mason-lspconfig").setup { ensure_installed = vim.tbl_keys(servers) }
  require("mason-lspconfig").setup_handlers {
    function(server)
      local server_opts = servers[server] or {}
      server_opts.capabilities = lsp_utils.capabilities()
      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end,
  }
end

return M
