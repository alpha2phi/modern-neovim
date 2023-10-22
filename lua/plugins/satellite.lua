return {
  "lewis6991/satellite.nvim",
  enabled = function()
    return vim.fn.has "nvim-0.10.0" == 1
  end,
  event = { "BufReadPre" },
  opts = {},
}
