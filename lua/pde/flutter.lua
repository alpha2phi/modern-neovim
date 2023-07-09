if not require("config").pde.flutter then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "dart" })
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    opts = function()
      return {}
    end,
    config = function(_, opts)
      require("flutter-tools").setup(opts)
    end,
  },
}
