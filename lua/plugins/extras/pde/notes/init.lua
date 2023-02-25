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
}
