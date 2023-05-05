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
        window = {
          border = "single", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
      }
      wk.register({
        w = { "<cmd>update!<CR>", "Save" },
        -- stylua: ignore
        q = { name = "Quit",
          q = { function() require("utils").quit() end, "Quit", },
          t = { "<cmd>tabclose<cr>", "Close Tab" },
        },
        a = { name = "+AI" },
        b = { name = "+Buffer" },
        d = { name = "+Debug" },
        D = { name = "+Database" },
        f = { name = "+File" },
        h = { name = "+Help" },
        j = { name = "+Jump" },
        g = { name = "+Git", h = { name = "Hunk" }, t = { name = "Toggle" } },
        n = { name = "+Notes" },
        p = { name = "+Project" },
        -- o = { name = "+Orgmode" },
        r = { name = "+Refactor" },
        t = { name = "+Test", N = { name = "Neotest" }, o = { "Overseer" } },
        v = { name = "+View" },
        z = { name = "+System" },
        -- stylua: ignore
        s = {
          name = "+Search",
          c = { function() require("utils.coding").cht() end, "Cheatsheets", },
          o = { function() require("utils.coding").stack_overflow() end, "Stack Overflow", },
          -- n = { name = "+Noice" },
        },
        c = {
          name = "+Code",
          g = { name = "Annotation" },
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
      }, { prefix = "<leader>", mode = { "n", "v" } })
    end,
  },
}
