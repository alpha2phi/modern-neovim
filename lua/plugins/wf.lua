return {
  "Cassin01/wf.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("wf").setup()
    local which_key = require "wf.builtin.which_key"
    local register = require "wf.builtin.register"
    local bookmark = require "wf.builtin.bookmark"
    local buffer = require "wf.builtin.buffer"
    local mark = require "wf.builtin.mark"

    -- Register
    vim.keymap.set(
      "n",
      "<Space>kr",
      -- register(opts?: table) -> function
      -- opts?: option
      register(),
      { noremap = true, silent = true, desc = "[wf.nvim] register" }
    )
  end,
}
