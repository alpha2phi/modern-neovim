local M = {}

M.open = function(file_path, buffer, pre_hook)
  local ok, Hydra = pcall(require, "hydra")
  if not ok then
    return
  end

  local _ = function(callback)
    return function()
      if pre_hook then
        pre_hook()
      else
        vim.cmd "wincmd w"
      end
      vim.schedule(callback)
    end
  end

  local hydra = Hydra {
    name = "",
    mode = { "n", "i" },
    config = {
      buffer = buffer,
      hint = {
        border = "rounded",
        position = "bottom",
      },
    },
    heads = {
      { "y", _(function()
        vim.fn.setreg("+", file_path)
      end), { private = true, desc = "Copy", exit = true } },
      {
        "Y",
        _(function()
          local relative_path = vim.fn.fnamemodify(file_path, ":~:.")
          vim.fn.setreg("+", relative_path)
        end),
        {
          private = true,
          desc = "Copy relative",
          exit = true,
        },
      },
    },
  }

  hydra:activate()
end

return M
