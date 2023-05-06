require "config.options"
require "config.lazy"

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("ModernNeovim", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    require "config.autocmds"
    require "config.keymaps"
    require "utils.contextmenu"
  end,
})
