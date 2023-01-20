return {
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tc", "<cmd>TestClass<cr>", desc = "Class" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "File" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Last" },
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Nearest" },
      { "<leader>ts", "<cmd>TestSuite<cr>", desc = "Suite" },
      { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Visit" },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1
      vim.g["test#python#runner"] = "pyunit" -- pytest
    end,
  },
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tNl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Last" },
      { "<leader>tNn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Nearest" },
    },
    dependencies = {
      "vim-test/vim-test",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "rouge8/neotest-rust",
    },
    config = function()
      local opts = {
        require "neotest-python" {
          dap = { justMyCode = false },
          runner = "unittest",
        },
        require "neotest-plenary",
        require "neotest-vim-test" {
          ignore_file_types = { "python", "vim", "lua" },
        },
        require "neotest-rust",

        -- overseer.nvim
        consumers = {
          overseer = require "neotest.consumers.overseer",
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
      require("neotest").setup(opts)
    end,
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>tor", "<cmd>OverseerRun<cr>", desc = "Run" },
    },
    -- cmd = {
    --   "OverseerToggle",
    --   "OverseerOpen",
    --   "OverseerRun",
    --   "OverseerBuild",
    --   "OverseerClose",
    --   "OverseerLoadBundle",
    --   "OverseerSaveBundle",
    --   "OverseerDeleteBundle",
    --   "OverseerRunCmd",
    --   "OverseerQuickAction",
    --   "OverseerTaskAction",
    -- },
    config = true,
  }, -- {
  --   "andythigpen/nvim-coverage",
  --   cmd = { "Coverage--[[  ]]" },
  --   config = true,
  -- },
}
