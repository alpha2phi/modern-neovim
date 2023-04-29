local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local l = require("luasnip.extras").lambda
local t = ls.text_node

local newline = function(text)
  return t { "", text }
end

local snippets = {
  ls.parser.parse_snippet("lm", "local M = {}\n\nfunction M.setup()\n  $1 \nend\n\nreturn M"),
  ls.parser.parse_snippet("for", "for ${1:i} = ${2:1}, ${3:n} do\n\t$0\nend"),
  ls.parser.parse_snippet("fun", "local function ${1:name}($2)\n\t$0\nend"),
  ls.parser.parse_snippet("while", "while ${1:cond} do\n\t$0\nend"),
  ls.parser.parse_snippet("mfun", "function M.${1:name}($2)\n\t$0\nend"),
  ls.parser.parse_snippet("pairs", "for ${1:key}, ${2:value} in pairs($3) do\n\t$0\nend"),
  ls.parser.parse_snippet("ipairs", "for ${1:i}, ${2:value} in ipairs($3) do\n\t$0\nend"),
  ls.parser.parse_snippet("if", "if ${1:cond} then\n\t$0\nend"),
  ls.parser.parse_snippet("ifn", "if not ${1:cond} then\n\t$0\nend"),
  s(
    "localreq",
    fmt('local {} = require("{}")', {
      l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
      i(1, "module"),
    })
  ),
  s(
    "preq",
    fmt('local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end', {
      l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
      i(1, "module"),
    })
  ),

  ls.parser.parse_snippet("ign", "--stylua: ignore"),
}

return snippets
