return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    -- stylua: ignore
    config = function ()
      vim.keymap.set("i", "<C-s>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    end,
  },
}
