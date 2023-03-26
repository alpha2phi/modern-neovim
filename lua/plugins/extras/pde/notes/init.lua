return {
  { "itchyny/calendar.vim", cmd = { "Calendar" } },
  { "folke/twilight.nvim", config = true, cmd = { "Twilight", "TwilightEnable", "TwilightDisable" } },
  { "folke/zen-mode.nvim", config = true, cmd = { "ZenMode" } },
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org", "norg" } },
  { "lukas-reineke/headlines.nvim", config = true, ft = { "markdown", "org", "norg" } },
  {
    "jbyuki/nabla.nvim",
    --stylua: ignore
    keys = {
      { "<leader>nn", function() require("nabla").popup() end, desc = "Notation", },
    },
    config = function()
      require("nabla").enable_virt()
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
    event = "VeryLazy",
    opts = { patterns = { "*.org", "*.norg", "*.tex" } },
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufFilePost" }, {
        pattern = opts.patterns,
        callback = function()
          vim.cmd.runtime [[ftplugin/pandoc.vim]]
        end,
      })
    end,
    dependencies = { "vim-pandoc/vim-pandoc-syntax" },
  },
}
