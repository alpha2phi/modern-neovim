return {
  { "itchyny/calendar.vim", cmd = { "Calendar" } },
  { "folke/twilight.nvim", opts = {}, cmd = { "Twilight", "TwilightEnable", "TwilightDisable" } },
  { "folke/zen-mode.nvim", opts = {}, cmd = { "ZenMode" } },
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org", "norg" } },
  { "lukas-reineke/headlines.nvim", opts = {}, ft = { "markdown", "org", "norg" } },
  {
    "jbyuki/nabla.nvim",
    --stylua: ignore
    keys = {
      { "<leader>nn", function() require("nabla").popup() end, desc = "Notation", },
    },
    config = function()
      require("nabla").enable_virt()
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
    ft = { "pandoc", "markdown", "org", "norg", "tex", "latex", "json", "html" },
    init = function()
      vim.g["pandoc#filetypes#handled"] = { "pandoc", "markdown", "latex", "json", "html" }
    end,
    dependencies = { "vim-pandoc/vim-pandoc-syntax" },
  },
}
