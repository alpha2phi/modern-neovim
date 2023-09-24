--- Install lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup {
  spec = {
    { import = "plugins" },
    { import = "plugins.ui" },
    { import = "plugins.notes" },
    { import = "plugins.ai" },
    { import = "pde" },
  },
  defaults = { lazy = true, version = nil },
  install = { missing = true, colorscheme = { "tokyonight", "gruvbox" } },
  dev = { patterns = jit.os:find "Windows" and {} or { "alpha2phi" } },
  checker = { enabled = true },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
      },
    },
  },
}
vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })
