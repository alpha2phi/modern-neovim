return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    -- stylua: ignore
    config = function ()
      vim.keymap.set("i", "<c-s>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<a-s>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("i", "<a-c>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    end,
  },
}
