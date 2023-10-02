return {
  "coffebar/neovim-project",
  event = "VeryLazy",
  opts = {
    projects = {
      "~/workspace/alpha2phi/*",
      "~/workspace/platform/*",
      "~/workspace/temp/*",
      "~/workspace/software/*",
    },
  },
  init = function()
    vim.opt.sessionoptions:append "globals"
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "Shatur/neovim-session-manager" },
  },
}
