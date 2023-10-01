return {
  "gabrielpoca/replacer.nvim",
  opts = {},
  keys = {
    {
      "<leader>rr",
      function()
        require("replacer").run()
      end,
      desc = "Replacer",
    },
  },
}
