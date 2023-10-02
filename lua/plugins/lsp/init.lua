return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "j-hui/fidget.nvim", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    opts = {
      servers = {
        dockerls = {},
      },
      setup = {},
      format = {
        timeout_ms = 3000,
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.servers").setup(plugin, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    enabled = false, -- use lspsaga
    config = true,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "<leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    enabled = function()
      return vim.fn.has "nvim-0.10.0" == 1
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },
  { "jay-babu/mason-null-ls.nvim", opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false } },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- { "rafcamlet/nvim-luapad", cmd = { "LuaRun", "Luapad" } },
  {
    "stevearc/conform.nvim",
    enabled = false,
    event = "BufReadPre",
    opts = {},
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false,
    event = "BufReadPre",
    opts = { ft = {} },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.ft
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "dnlhc/glance.nvim",
    enabled = false,
    cmd = { "Glance" },
    opts = {},
  },
  {
    "luckasRanarison/clear-action.nvim",
    enabled = false,
    event = "VeryLazy",
    cmd = { "CodeActionToggleSigns", "CodeActionToggleLabel" },
    opts = {},
  },
}
