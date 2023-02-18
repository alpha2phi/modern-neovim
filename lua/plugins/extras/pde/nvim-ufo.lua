return {
  {
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = function(plugin, opts)
      require("ufo").setup()
    end,
  },
}
