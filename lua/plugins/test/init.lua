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
      { "<leader>tNF", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
      { "<leader>tNL", "<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
      { "<leader>tNa", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach" },
      { "<leader>tNf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
      { "<leader>tNl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Last" },
      { "<leader>tNn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Nearest" },
      { "<leader>tNN", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
      { "<leader>tNo", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
      { "<leader>tNs", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop" },
      { "<leader>tNS", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
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
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
            runner = "unittest",
          },
          require "neotest-plenary",
          require "neotest-vim-test" {
            ignore_file_types = { "python", "vim", "lua" },
          },
          require "neotest-rust",
        },
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
      { "<leader>toR", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
      { "<leader>toa", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      { "<leader>tob", "<cmd>OverseerBuild<cr>", desc = "Build" },
      { "<leader>toc", "<cmd>OverseerClose<cr>", desc = "Close" },
      { "<leader>tod", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      { "<leader>tol", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
      { "<leader>too", "<cmd>OverseerOpen<cr>", desc = "Open" },
      { "<leader>toq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
      { "<leader>tor", "<cmd>OverseerRun<cr>", desc = "Run" },
      { "<leader>tos", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
      { "<leader>tot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
    },
    config = true,
  },
  -- {
  --   "andythigpen/nvim-coverage",
  --   cmd = { "Coverage" },
  --   config = true,
  -- },
}
