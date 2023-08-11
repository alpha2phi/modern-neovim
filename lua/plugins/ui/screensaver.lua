return {
  {
    "tamton-aquib/duck.nvim",
    keys = {
      -- stylua: ignore
      { "<leader>zd", function() require("duck").hatch() end, desc = "Duck Hatch" },
      -- stylua: ignore
      { "<leader>zD", function() require("duck").cook() end, desc = "Duck Cook" },
    },
  },
  {
    "folke/drop.nvim",
    event = "VeryLazy",
    opts = function()
      math.randomseed(os.time())
      local theme = ({ "leaves", "snow", "stars", "xmas", "spring", "summer" })[math.random(1, 6)]
      return {
        max = 80, -- maximum number of drops on the screen
        interval = 150, -- every 150ms we update the drops
        screensaver = 1000 * 60 * 5, -- 5 minutes
        theme = theme,
      }
    end,
  },
}
