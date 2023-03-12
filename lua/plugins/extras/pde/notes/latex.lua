--TODO:
-- https://github.com/WhiteBlackGoose/nvim-latex-preconfig/blob/master/init.lua
-- https://gitlab.com/teunphil/humanlatex#vimtex
return {
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      -- Run compilation on start
      vim.cmd [[
        :autocmd BufNewFile,BufRead *.tex VimtexCompile
      ]]

      -- Live compilation
      vim.g.vimtex_compiler_latexmk = {
        build_dir = ".out",
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-synctex=1",
        },
      }
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_fold_enabled = true
    end,
  },
}
