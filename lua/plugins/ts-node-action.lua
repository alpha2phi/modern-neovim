return {
  "ckolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  enabled = true,
  opts = {},
  keys = {
    {
      "<leader>cn",
      function()
        require("ts-node-action").node_action()
      end,
      desc = "Node Action",
    },
  },
}
