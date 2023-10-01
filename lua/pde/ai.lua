if not require("config").pde.ai then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local Utils = require "utils"
      local colors = {
        [""] = Utils.fg "Special",
        ["Normal"] = Utils.fg "Special",
        ["Warning"] = Utils.fg "DiagnosticError",
        ["InProgress"] = Utils.fg "DiagnosticWarn",
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require("config.icons").icons.kinds.Copilot
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          if not package.loaded["copilot"] then
            return
          end
          local status = require("copilot.api").status.data
          return colors[status.status] or colors[""]
        end,
      })
    end,
  },
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    enabled = true,
    -- stylua: ignore
    config = function ()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<A-l>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<A-f>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<A-b>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<A-c>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("i", "<A-s>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    end,
  },
  {
    "huggingface/hfcc.nvim",
    event = "InsertEnter",
    enabled = false,
    opts = {
      model = "bigcode/starcoder",
    },
  },
  {
    "codota/tabnine-nvim",
    enabled = false,
    build = "./dl_binaries.sh",
    event = "VeryLazy",
    config = function()
      require("tabnine").setup {
        disable_auto_comment = true,
        accept_keymap = "<A-l>",
        dismiss_keymap = "<A-c>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt" },
      }
    end,
  },
  {
    "mthbernardes/codeexplain.nvim",
    enabled = false,
    cmd = "CodeExplain",
    build = function()
      vim.cmd [[silent UpdateRemotePlugins]]
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    keys = {
      { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "Chat" },
      { "<leader>ac", "<cmd>ChatGPTRun complete_code<cr>", mode = { "n", "v" }, desc = "Complete Code" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", mode = { "n", "v" }, desc = "Edit with Instructions" },
    },
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
      "NeoAIShortcut",
    },
    keys = {
      { "<leader>as", desc = "Summarize Text" },
      { "<leader>ag", desc = "Generate Git Message" },
    },
    opts = {},
    config = function()
      require("neoai").setup {
        -- Options go here
      }
    end,
  },
  {
    "sourcegraph/sg.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {},
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>sD", function() require("wtf").ai() end, desc = "Search Diagnostic with AI" },
      { "<leader>sd", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
    },
  },
}
