return {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  config = {
    kind = "split",
    signs = {
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
    integrations = { diffview = true },
  },
  keys = {
    { "<leader>gs", "<cmd>Neogit kind=floating<cr>", desc = "Status" },
  },
}
