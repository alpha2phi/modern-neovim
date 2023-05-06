require "config.options"
require "config.lazy"

if vim.fn.argc(-1) == 0 then
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("ModernNeovim", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      require "config.autocmds"
      require "config.keymaps"
      require "utils.contextmenu"
    end,
  })
else
  require "config.autocmds"
  require "config.keymaps"
  require "utils.contextmenu"
end
