return {
  {
    "cbochs/portal.nvim",
    keys = {
      { "<C-o>", "<cmd>Portal jumplist backward<cr>", desc = "Jump Backward" },
      { "<C-i>", "<cmd>Portal jumplist forward<cr>", desc = "Jump Forward" },
      { "g;", "<cmd>Portal changelist backward<cr>", desc = "Change Backward" },
      { "g,", "<cmd>Portal changelist forward<cr>", desc = "Change Forward" },
    },
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
    enabled = false,
  },
}
