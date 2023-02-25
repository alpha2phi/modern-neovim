return {
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    rocks = "luautf8",
    opts = {},
    enabled = false,
  },
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown" }, opts = {} },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  { "mzlogin/vim-markdown-toc", ft = { "markdown" } },
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      home = vim.env.HOME .. "/zettelkasten",
    },
    ft = { "markdown" },
  },
  {
    "epwalsh/obsidian.nvim",
    opts = {
      dir = vim.env.HOME .. "/obsidian",
      completion = {
        nvim_cmp = true,
      },
    },
    ft = { "markdown" },
  },
  -- { "toppair/peek.nvim", run = "deno task --quiet build:fast" },
  -- glow.nvim
  -- https://github.com/rockerBOO/awesome-neovim#markdown-and-latex
}
