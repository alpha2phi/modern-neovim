local function gitsigns_menu()
  local gitsigns = require "gitsigns"

  local hint = [[
 _J_: Next hunk   _s_: Stage Hunk        _d_: Show Deleted   _b_: Blame Line
 _K_: Prev hunk   _u_: Undo Last Stage   _p_: Preview Hunk   _B_: Blame Show Full 
 ^ ^              _S_: Stage Buffer      ^ ^                 _/_: Show Base File
 ^
 ^ ^              _<Enter>_: Neogit              _q_: Exit
]]

  return {
    name = "Git",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
        position = "bottom",
      },
      on_enter = function()
        vim.cmd "mkview"
        vim.cmd "silent! %foldopen!"
        vim.bo.modifiable = false
        gitsigns.toggle_signs(true)
        gitsigns.toggle_linehl(true)
      end,
      on_exit = function()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd "loadview"
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        vim.cmd "normal zv"
        gitsigns.toggle_signs(false)
        gitsigns.toggle_linehl(false)
        gitsigns.toggle_deleted(false)
      end,
    },
    body = "<A-g>",
    heads = {
      {
        "J",
        function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gitsigns.next_hunk()
          end)
          return "<Ignore>"
        end,
        { expr = true, desc = "Next Hunk" },
      },
      {
        "K",
        function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gitsigns.prev_hunk()
          end)
          return "<Ignore>"
        end,
        { expr = true, desc = "Prev Hunk" },
      },
      { "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage Hunk" } },
      { "u", gitsigns.undo_stage_hunk, { desc = "Undo Last Stage" } },
      { "S", gitsigns.stage_buffer, { desc = "Stage Buffer" } },
      { "p", gitsigns.preview_hunk, { desc = "Preview Hunk" } },
      { "d", gitsigns.toggle_deleted, { nowait = true, desc = "Toggle Deleted" } },
      { "b", gitsigns.blame_line, { desc = "Blame" } },
      {
        "B",
        function()
          gitsigns.blame_line { full = true }
        end,
        { desc = "Blame Show Full" },
      },
      { "/", gitsigns.show, { exit = true, desc = "Show Base File" } }, -- show the base of the file
      { "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
      { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
    },
  }
end

local function dap_menu()
  local dap = require "dap"
  local dapui = require "dapui"
  local dap_widgets = require "dap.ui.widgets"

  local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close 
 _g_: Get Session                   _i_: Step Into 
 _h_: Hover Variables               _o_: Step Over 
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause     
 ^ ^               _q_: Quit 
]]

  return {
    name = "Debug",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
        position = "middle-right",
      },
    },
    mode = "n",
    body = "<A-d>",
    -- stylua: ignore
    heads = {
      { "C", function() dap.set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
      { "E", function() dapui.eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
      { "R", function() dap.run_to_cursor() end, desc = "Run to Cursor", },
      { "S", function() dap_widgets.scopes() end, desc = "Scopes", },
      { "U", function() dapui.toggle() end, desc = "Toggle UI", },
      { "X", function() dap.close() end, desc = "Quit", },
      { "b", function() dap.step_back() end, desc = "Step Back", },
      { "c", function() dap.continue() end, desc = "Continue", },
      { "d", function() dap.disconnect() end, desc = "Disconnect", },
      { "e", function() dapui.eval() end, mode = {"n", "v"}, desc = "Evaluate", },
      { "g", function() dap.session() end, desc = "Get Session", },
      { "h", function() dap_widgets.hover() end, desc = "Hover Variables", },
      { "i", function() dap.step_into() end, desc = "Step Into", },
      { "o", function() dap.step_over() end, desc = "Step Over", },
      { "p", function() dap.pause.toggle() end, desc = "Pause", },
      { "r", function() dap.repl.toggle() end, desc = "Toggle REPL", },
      { "s", function() dap.continue() end, desc = "Start", },
      { "t", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
      { "u", function() dap.step_out() end, desc = "Step Out", },
      { "x", function() dap.terminate() end, desc = "Terminate", },
      { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
    },
  }
end

return {
  {
    "anuvyklack/hydra.nvim",
    event = "VeryLazy",
    config = function(_, _)
      local Hydra = require "hydra"
      Hydra(gitsigns_menu())
      Hydra(dap_menu())
    end,
  },
}
