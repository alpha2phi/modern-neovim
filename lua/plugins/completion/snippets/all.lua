local ls = require "luasnip"
local s = ls.snippet
local f = ls.function_node
local p = require("luasnip.extras").partial

local snippets = {
  s({ trig = "$ymd", name = "Current date", dscr = "Insert the current date" }, {
    p(os.date, "%Y-%m-%d"),
  }),

  s(
    "$date",
    f(function()
      return os.date "%D - %H:%M"
    end)
  ),
}

return snippets
