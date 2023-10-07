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

local function lsp_menu()
  local cmd = require("hydra.keymap-util").cmd
  return {
    name = "LSP Mode",
    mode = { "n" },
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        type = "window",
        position = "bottom-right",
        border = "rounded",
        show_name = true,
      },
    },
    hint = [[
    LSP
^
Common Actions
- _h_: Show Hover Doc
- _f_: Format Buffer
- _a_: Code Actions
- _s_: Jump to Definition
- _d_: Show Diagnostics
- _w_: Show Workspace Diagnostics
^
Help
- _e_: Show Declarations
- _D_: Show Type Definition
- _j_: Show Sig Help
- _o_: Show Implementation
- _r_: Show References
^
_;_/_q_/_<Esc>_: Exit Hydra
]],
    body = "<A-z>",
    heads = {
      { "s", cmd "TroubleToggle lsp_definitions", { desc = "Jump to Definition", silent = true } },
      { "h", cmd "Lspsaga hover_doc", { desc = "Show Hover Doc", silent = true } },
      { "o", cmd "TroubleToggle lsp_implementations", { desc = "Show Implementations", silent = true } },
      { "j", vim.lsp.buf.signature_help, { desc = "Show Sig Help", silent = true } },
      { "r", cmd "TroubleToggle lsp_references", { desc = "Show References", silent = true } },
      {
        "f",
        function()
          vim.lsp.buf.format { async = true }
        end,
        { desc = "Format Buffer", silent = true },
      },
      { "a", vim.lsp.buf.code_action, { desc = "Show Code Actions", silent = true } },
      { "d", cmd "TroubleToggle document_diagnostics", { desc = "Show Diagnostics", silent = true } },
      { "w", cmd "TroubleToggle workspace_diagnostics", { desc = "Show Workspace Diagnostics", silent = true } },
      { "D", cmd "TroubleToggle lsp_definitions", { desc = "Show Type Definition", silent = true } },
      { "e", vim.lsp.buf.declaration, { desc = "Show Declaration", silent = true } },
      { ";", nil, { desc = "quit", exit = true, nowait = true } },
      { "q", nil, { desc = "quit", exit = true, nowait = true } },
      { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
    },
  }
end

local function quick_menu()
  local cmd = require("hydra.keymap-util").cmd
  return {
    name = "Quick Menu",
    mode = { "n" },
    hint = [[
        Quick Menu
^
_f_: Show Terminal (float)      
_v_: Open Terminal (vertical)
_h_: Open Terminal (horizontal)

_x_: Open Quickfix
_l_: Open Location List

_s_: Buffer Fuzzy Search        
_o_: Open Symbols Outline      

_t_: Show Help Tags            
_k_: Show Keymaps
_c_: Show Vim Commands
_m_: Show Man Pages            
^
^ ^  _q_/_<Esc>_: Exit Hydra
    ]],
    config = {
      color = "teal",
      invoke_on_body = true,
      hint = {
        type = "window",
        position = "bottom",
        border = "rounded",
        show_name = true,
      },
    },
    body = "<A-q>",
    heads = {
      { "t", cmd "Telescope help_tags", { desc = "Open Help Tags", silent = true } },
      { "k", ":lua require('telescope.builtin').keymaps()<CR>", { desc = "Open Neovim Keymaps", silent = true } },
      { "c", cmd "Telescope commands", { desc = "Open Available Telescope Commands", silent = true } },
      { "m", cmd "Telescope man_pages", { desc = "Opens Man Pages", silent = true } },

      { "s", cmd "Telescope current_buffer_fuzzy_find skip_empty_lines=true", { desc = "Fuzzy find in current buffer", silent = true } },
      { "o", cmd "Telescope aerial", { desc = "Opens Symbols Outline", exit = true, silent = true } },

      { "x", cmd "TroubleToggle quickfix", { desc = "Opens Quickfix", silent = true } },
      { "l", cmd "TroubleToggle loclist", { desc = "Opens Location List", silent = true } },

      { "f", cmd "ToggleTerm direction=float", { desc = "Floating Terminal", silent = true } },
      { "v", cmd "ToggleTerm direction=vertical", { desc = "Vertical Terminal", silent = true } },
      { "h", cmd "ToggleTerm direction=horizontal", { desc = "Horizontal Terminal", silent = true } },

      { "q", nil, { desc = "quit", exit = true, nowait = true } },
      { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
    },
  }
end

return {
  {
    "anuvyklack/hydra.nvim",
    event = { "BufReadPre" },
    opts = {
      specs = {
        gitsigns = gitsigns_menu,
        quick = quick_menu,
      },
    },
    config = function(_, opts)
      local hydra = require "hydra"
      for s, _ in pairs(opts.specs) do
        hydra(opts.specs[s]())
      end
    end,
  },
}
