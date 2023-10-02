return {
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tc", "<cmd>w|TestClass<cr>", desc = "Class" },
      { "<leader>tf", "<cmd>w|TestFile<cr>", desc = "File" },
      { "<leader>tl", "<cmd>w|TestLast<cr>", desc = "Last" },
      { "<leader>tn", "<cmd>w|TestNearest<cr>", desc = "Nearest" },
      { "<leader>ts", "<cmd>w|TestSuite<cr>", desc = "Suite" },
      { "<leader>tv", "<cmd>w|TestVisit<cr>", desc = "Visit" },
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
      { "<leader>tNF", "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
      { "<leader>tNL", "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
      { "<leader>tNa", "<cmd>w|lua require('neotest').run.attach()<cr>", desc = "Attach" },
      { "<leader>tNf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
      { "<leader>tNl", "<cmd>w|lua require('neotest').run.run_last()<cr>", desc = "Last" },
      { "<leader>tNn", "<cmd>w|lua require('neotest').run.run()<cr>", desc = "Nearest" },
      { "<leader>tNN", "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
      { "<leader>tNo", "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
      { "<leader>tNs", "<cmd>w|lua require('neotest').run.stop()<cr>", desc = "Stop" },
      { "<leader>tNS", "<cmd>w|lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
      "stevearc/overseer.nvim",
    },
    opts = function()
      return {
        adapters = {
          require "neotest-vim-test" {
            ignore_file_types = { "python", "vim", "lua" },
          },
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            if require("utils").has "trouble.nvim" then
              vim.cmd "Trouble quickfix"
            else
              vim.cmd "copen"
            end
          end,
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
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
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
  {
    "anuvyklack/hydra.nvim",
    opts = {
      specs = {
        test = function()
          local cmd = require("hydra.keymap-util").cmd
          local hint = [[
^
_f_: File
_F_: All Files
_l_: Last
_n_: Nearest
^
_d_: Debug File
_L_: Debug Last
_N_: Debug Nearest
^
_o_: Output
_S_: Summary
^
_a_: Attach
_s_: Stop
^
^ ^  _q_: Quit 
          ]]
          return {
            name = "Test",
            hint = hint,
            config = {
              color = "pink",
              invoke_on_body = true,
              hint = {
                border = "rounded",
                position = "top-left",
              },
            },
            mode = "n",
            body = "<A-t>",
            heads = {
              { "F", cmd "w|lua require('neotest').run.run(vim.loop.cwd())", desc = "All Files" },
              { "L", cmd "w|lua require('neotest').run.run_last({strategy = 'dap'})", desc = "Debug Last" },
              { "N", cmd "w|lua require('neotest').run.run({strategy = 'dap'})", desc = "Debug Nearest" },
              { "S", cmd "w|lua require('neotest').summary.toggle()", desc = "Summary" },
              { "a", cmd "w|lua require('neotest').run.attach()", desc = "Attach" },
              { "d", cmd "w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'}", desc = "Debug File" },
              { "f", cmd "w|lua require('neotest').run.run(vim.fn.expand('%'))", desc = "File" },
              { "l", cmd "w|lua require('neotest').run.run_last()", desc = "Last" },
              { "n", cmd "w|lua require('neotest').run.run()", desc = "Nearest" },
              { "o", cmd "w|lua require('neotest').output.open({ enter = true })", desc = "Output" },
              { "s", cmd "w|lua require('neotest').run.stop()", desc = "Stop" },
              { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
            },
          }
        end,
      },
    },
  },
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage" },
    config = function()
      require("coverage").setup()
    end,
  },
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },
}
