return {
  {
    "folke/styler.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      themes = {
        markdown = { colorscheme = "tokyonight" },
        help = { colorscheme = "tokyonight" },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "moon",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      local tokyonight = require "tokyonight"
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  { "rebelot/kanagawa.nvim", enabled = false, lazy = true, name = "kanagawa" },
  { "sainnhe/gruvbox-material", enabled = false, lazy = true, name = "gruvbox-material" },
  {
    "sainnhe/everforest",
    enabled = false,
    lazy = true,
    name = "everforest",
    config = function()
      vim.cmd.colorscheme "gruvbox-material"
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    enabled = false,
    lazy = true,
    config = function()
      require("gruvbox").setup()
    end,
  },
}
