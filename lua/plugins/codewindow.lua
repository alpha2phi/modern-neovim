return {
  "gorbit99/codewindow.nvim",
  enabled = false,
  keys = { { "<leader>m", mode = { "n", "v" } } },
  config = function()
    local codewindow = require "codewindow"
    codewindow.setup()
    codewindow.apply_default_keybinds()
  end,
}
