return {
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup { useDefaultKeymaps = true }
    end,
    event = "VeryLazy",
  },
  { "axieax/urlview.nvim", cmd = { "UrlView" } },
}
