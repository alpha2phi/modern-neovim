return {
  {
    "mrjones2014/legendary.nvim",
    keys = {
      { "<C-S-p>", "<cmd>Legendary<cr>", desc = "Legendary" },
      { "<leader>hc", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      which_key = { auto_register = true },
    },
  },
  {
    "folke/which-key.nvim",
    dependencies = {
      "mrjones2014/legendary.nvim",
    },
    event = "VeryLazy",
    config = function()
      local wk = require "which-key"
      wk.setup {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
      }
      wk.register({
        w = { "<cmd>update!<CR>", "Save" },
        q = { "<cmd>lua require('utils').quit()<CR>", "Quit" },
        b = { name = "+Buffer" },
        f = { name = "+File" },
        h = { name = "+Help" },
        g = { name = "+Git" },
        p = { name = "+Project" },
        v = { name = "+View" },
        ["sn"] = { name = "+Noice" },
        s = {
          name = "+Search",
          c = {
            function()
              require("utils.cht").cht()
            end,
            "Cheatsheets",
          },
          s = {
            function()
              require("utils.cht").stack_overflow()
            end,
            "Stack Overflow",
          },
        },
        c = {
          name = "+Code",
          x = {
            name = "Swap Next",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
          X = {
            name = "Swap Previous",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
        },
      }, { prefix = "<leader>" })
    end,
  },
}
