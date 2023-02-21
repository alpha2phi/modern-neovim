return {
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    rocks = "luautf8",
    opts = {},
  },
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown" }, opts = {} },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
  },
  -- glow.nvim
  -- peek.nvim
  -- https://github.com/rockerBOO/awesome-neovim#markdown-and-latex
  -- https://github.com/renerocksai/telekasten.nvim
}
