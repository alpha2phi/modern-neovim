return {
  {
    "SmiteshP/nvim-navbuddy",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    --stylua: ignore
    keys = {
      { "<leader>vO", function() require("nvim-navbuddy").open() end, desc = "Code Outline (navbuddy)", },
    },
    opts = {},
    config = function()
      local lsp_utils = require "plugins.lsp.utils"
      lsp_utils.on_attach(function(client, buffer)
        if client.name ~= "null-ls" then
          local navbuddy = require "nvim-navbuddy"
          navbuddy.attach(client, buffer)
        end
      end)
    end,
  },
}
