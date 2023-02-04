return {
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next ToDo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous ToDo" },
      { "<leader>ct", "<cmd>TodoTrouble<cr>", desc = "ToDo (Trouble)" },
      { "<leader>cT", "<cmd>TodoTelescope<cr>", desc = "ToDo" },
    },
  },
}
