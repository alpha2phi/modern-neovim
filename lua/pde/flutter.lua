if not require("config").pde.flutter then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "dart" })
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        -- ui = { border = as.ui.current.border },
        debugger = {
          -- enabled = is_nightly,
          -- run_via_dap = is_nightly,
          exception_breakpoints = {},
        },
        outline = { auto_open = false },
        decorations = {
          statusline = { device = true, app_version = true },
        },
        widget_guides = { enabled = true, debug = false },
        -- dev_log = { enabled = not is_nightly, open_cmd = 'tabedit' },
        lsp = {
          color = {
            enabled = true,
            background = true,
            virtual_text = false,
          },
          settings = {
            showTodos = false,
            renameFilesWithClasses = "always",
            updateImportsOnRename = true,
            completeFunctionCalls = true,
            lineLength = 100,
          },
        },
      }
    end,
    dependencies = {
      { "RobertBrunhage/flutter-riverpod-snippets" },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "sidlatau/neotest-dart" },
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-dart" { command = "flutter" },
      })
    end,
  },
}
