return {
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Last" },
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Nearest" },
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
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
    },
    config = function()
      local opts = {
        require "neotest-python" {
          dap = { justMyCode = false },
        },
        require "neotest-plenary",
        require "neotest-vim-test" {
          ignore_file_types = { "python", "vim", "lua" },
        },
      }
      require("neotest").setup(opts)
    end,
  },
  -- {
  --   "andythigpen/nvim-coverage",
  -- },
}
