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
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  { "mzlogin/vim-markdown-toc", ft = { "markdown" } },
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      home = vim.env.HOME .. "/zettelkasten",
    },
    enabled = false,
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
    enabled = false,
    ft = { "markdown" },
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow", enabled = true },
  { "toppair/peek.nvim", config = true, ft = { "markdown" }, enabled = false, build = "deno task --quiet build:fast" },
  -- glow.nvim
  -- https://github.com/rockerBOO/awesome-neovim#markdown-and-latex
}
