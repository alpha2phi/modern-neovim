return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension "refactoring"
    end,
    -- stylua: ignore
    keys = {
      { "<leader>cF", function() require("telescope").extensions.refactoring.refactors() end, mode = { "v" }, desc = "Refactor", },
    },
  },
}
