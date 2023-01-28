local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "jbyuki/one-small-step-for-vimkind" },
  },
  keys = {
    -- stylua: ignore
    { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
    -- stylua: ignore
    { "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
    -- stylua: ignore
    { "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
    -- stylua: ignore
    { "<leader>dU", function() require("dapui").toggle() end, desc = "Toggle UI", },
    -- stylua: ignore
    { "<leader>db", function() require("dap").step_back() end, desc = "Step Back", },
    -- stylua: ignore
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
    -- stylua: ignore
    { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect", },
    -- stylua: ignore
    { "<leader>de", function() require("dapui").eval() end, desc = "Evaluate", },
    -- stylua: ignore
    { "<leader>dg", function() require("dap").session() end, desc = "Get Session", },
    -- stylua: ignore
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
    -- stylua: ignore
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
    -- stylua: ignore
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
    -- stylua: ignore
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
    -- stylua: ignore
    { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
    -- stylua: ignore
    { "<leader>dq", function() require("dap").close() end, desc = "Quit", },
    -- stylua: ignore
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
    -- stylua: ignore
    { "<leader>ds", function() require("dap").continue() end, desc = "Start", },
    -- stylua: ignore
    { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    -- stylua: ignore
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
    -- stylua: ignore
    { "<leader>du", function() require("dap").step_out() end, desc = "Step Out", },
  },
  opts = {},
  config = function(_, opts)
    require("nvim-dap-virtual-text").setup {
      commented = true,
    }

    local dap, dapui = require "dap", require "dapui"
    dapui.setup {}

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Lua debugging
    require("plugins.dap.lua").setup()

    -- Other debuggers
    if opts.setup then
      opts.setup()
    end
  end,
}

return M
