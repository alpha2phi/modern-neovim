local M = {}

function M.chat()
  print "todo"
end

local output = vim.api.nvim_call_function("OpenAIGPTChat", { "Python hello world program" })

vim.print("output", output)

return M
