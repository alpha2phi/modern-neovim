if not require("config").pde.jupyter then
  return {}
end

local CELL_MARKER_COLOR = "#C5C5C5"
local CELL_MARKER = "^# %%%%"
local CELL_MARKER_SIGN = "cell_marker_sign"

vim.api.nvim_set_hl(0, "cell_marker_hl", { bg = CELL_MARKER_COLOR })
vim.fn.sign_define(CELL_MARKER_SIGN, { linehl = "cell_marker_hl" })

local function highlight_cell_marker(bufnr, line)
  local sign_name = CELL_MARKER_SIGN
  local sign_text = "%%"
  vim.fn.sign_place(line, CELL_MARKER_SIGN, sign_name, bufnr, {
    lnum = line,
    priority = 10,
    text = sign_text,
  })
end

local function show_cell_markers()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace(CELL_MARKER_SIGN, { buffer = bufnr })
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  for line = 1, total_lines do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
    if line_content ~= "" and line_content:find(CELL_MARKER) then
      highlight_cell_marker(bufnr, line)
    end
  end
end

local function show_cell_marker()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
  if line_content ~= "" and line_content:find(CELL_MARKER) then
    highlight_cell_marker(bufnr, line)
  else
    vim.fn.sign_unplace(CELL_MARKER_SIGN, { buffer = bufnr, id = line })
  end
end

local function select_cell()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_row = vim.api.nvim_win_get_cursor(0)[1]
  local current_col = vim.api.nvim_win_get_cursor(0)[2]

  local start_line = nil
  local end_line = nil

  for line = current_row, 1, -1 do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
    if line_content:find(CELL_MARKER) then
      start_line = line
      break
    end
  end
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for line = current_row + 1, line_count do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
    if line_content:find(CELL_MARKER) then
      end_line = line
      break
    end
  end

  if not start_line then
    start_line = 1
  end
  if not end_line then
    end_line = line_count
  end
  return current_row, current_col, start_line, end_line
end

local function execute_cell()
  local current_row, current_col, start_line, end_line = select_cell()
  if start_line and end_line then
    vim.fn.setpos("'<", { 0, start_line + 1, 0, 0 })
    vim.fn.setpos("'>", { 0, end_line - 1, 0, 0 })
    require("iron.core").visual_send()
    vim.api.nvim_win_set_cursor(0, { current_row, current_col })
  end
end

local function delete_cell()
  local _, _, start_line, end_line = select_cell()
  if start_line and end_line then
    local rows_to_select = end_line - start_line - 1
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd("normal!V " .. rows_to_select .. "j")
    vim.cmd "normal!d"
    vim.cmd "normal!k"
  end
end

local function navigate_cell(up)
  local is_up = up or false
  local _, _, start_line, end_line = select_cell()
  if is_up and start_line ~= 1 then
    vim.api.nvim_win_set_cursor(0, { start_line - 1, 0 })
  elseif end_line then
    local bufnr = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    if end_line ~= line_count then
      vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
      _, _, start_line, end_line = select_cell()
      vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
    end
  end
end

local function insert_cell(content)
  local _, _, _, end_line = select_cell()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = end_line
  if end_line ~= 1 then
    line = end_line - 1
    vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
  else
    line = end_line
    vim.api.nvim_win_set_cursor(0, { end_line, 0 })
  end

  vim.cmd "normal!2o"
  vim.api.nvim_buf_set_lines(bufnr, line, line + 1, false, { content })
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  highlight_cell_marker(bufnr, current_line - 1)
  vim.cmd "normal!2o"
  vim.cmd "normal!k"
end

local function insert_code_cell()
  insert_cell "# %%"
end

local function insert_markdown_cell()
  insert_cell "# %% [markdown]"
end

local function repl_menu()
  local cmd = require("hydra.keymap-util").cmd

  local hint = [[
 ^
 _e_: Execute Cell
 _i_: Insert Cell
 _j_: Next Cell
 _k_: Previous Cell
 _r_: Insert Markdown Cell
 _x_: Delete Cell
 ^
 _s_: Send Motion
 _l_: Send Line
 _t_: Send Until Cursor
 _f_: Send File
 ^
 _R_: Show REPL
 _C_: Close REPL
 _S_: Restart REPL
 _F_: Focus
 _H_: Hide
 ^
 _c_: Clear
 _L_: Clear Highlight
 _<CR>_: ENTER
 _I_: Interrupt
 ^
 ^ ^  _q_: Quit 
]]

  return {
    name = "REPL",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
        position = "top-left",
      },
    },
    mode = "n",
    body = "<A-n>",
    -- stylua: ignore
    heads = {
      { "e", execute_cell, desc = "Execute Cell", },
      { "i", insert_code_cell, desc = "Insert Cell", },
      { "j", navigate_cell , desc = "Next Cell", },
      { "k", function() navigate_cell(true) end, desc = "Previous Cell", },
      { "r", insert_markdown_cell, desc = "Insert Markdown Cell", },
      { "x", delete_cell, desc = "Delete Cell", },
      { "s", function() require("iron.core").run_motion("send_motion") end, desc = "Send Motion" },
      { "l", function() require("iron.core").send_line() end, desc = "Send Line" },
      { "t", function() require("iron.core").send_until_cursor() end, desc = "Send Until Cursor" },
      { "f", function() require("iron.core").send_file() end, desc = "Send File" },
      { "L", function() require("iron.marks").clear_hl() end, mode = {"v"}, desc = "Clear Highlight" },
      { "<CR>", function() require("iron.core").send(nil, string.char(13)) end, desc = "ENTER" },
      { "I", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt" },
      { "C", function() require("iron.core").close_repl() end, desc = "Close REPL" },
      { "c", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear" },
      { "R", cmd("IronRepl"), desc = "REPL" },
      { "S", cmd("IronRestart"), desc = "Restart" },
      { "F", cmd("IronFocus"), desc = "Focus" },
      { "H", cmd("IronHide"), desc = "Hide" },
      { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
    },
  }
end

return {
  {
    "goerz/jupytext.vim",
    build = "pip install jupytext",
    event = "VeryLazy",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      -- The destination format: 'ipynb', 'markdown' or 'script', or a file extension: 'md', 'Rmd', 'jl', 'py', 'R', ..., 'auto' (script
      -- extension matching the notebook language), or a combination of an extension and a format name, e.g. md:markdown, md:pandoc,
      -- md:myst or py:percent, py:light, py:nomarker, py:hydrogen, py:sphinx. The default format for scripts is the 'light' format,
      -- which uses few cell markers (none when possible). Alternatively, a format compatible with many editors is the 'percent' format,
      -- which uses '# %%' as cell markers. The main formats (markdown, light, percent) preserve notebooks and text documents in a
      -- roundtrip. Use the --test and and --test-strict commands to test the roundtrip on your files. Read more about the available
      -- formats at https://jupytext.readthedocs.io/en/latest/formats.html (default: None)
      vim.g.jupytext_fmt = "py:percent"

      -- Autocmd to set cell markers
      vim.api.nvim_create_autocmd({ "BufEnter" }, { -- "BufWriteCmd"
        group = vim.api.nvim_create_augroup("au_show_cell_markers", { clear = true }),
        pattern = { "*.py", "*.ipynb", "*.r", "*.jl", "*.scala" },
        callback = function()
          vim.schedule(show_cell_markers)
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("au_check_cell_marker", { clear = true }),
        pattern = { "*.py", "*.ipynb", "*.r", "*.jl", "*.scala" },
        callback = function()
          vim.schedule(show_cell_marker)
        end,
      })
    end,
  },
  {
    "Vigemus/iron.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here

          repl_definition = {
            python = require("iron.fts.python").ipython,
            scala = require("iron.fts.scala").scala,
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require("iron.view").right "50%",
        },
        -- If the highliht is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>x", desc = "+REPL" },
      { "<leader>xm", desc = "+Mark" },
      { "<A-e>", execute_cell, desc = "Execute Cell" },
      { "<A-i>", insert_code_cell, desc = "Insert Code Cell" },
      { "<A-r>", insert_markdown_cell, desc = "Insert Markdown Cell" },
      { "<A-x>", delete_cell, desc = "Delete Cell" },
      { "<A-j>", navigate_cell, desc = "Next Cell" },
      { "<A-k>", function() navigate_cell(true) end, desc = "Previous Cell" },
      { "<leader>xs", function() require("iron.core").run_motion("send_motion") end, desc = "Send Motion" },
      { "<leader>xs", function() require("iron.core").visual_send() end, mode = {"v"}, desc = "Send" },
      { "<leader>xl", function() require("iron.core").send_line() end, desc = "Send Line" },
      { "<leader>xt", function() require("iron.core").send_until_cursor() end, desc = "Send Until Cursor" },
      { "<leader>xf", function() require("iron.core").send_file() end, desc = "Send File" },
      { "<leader>xL", function() require("iron.marks").clear_hl() end, mode = {"v"}, desc = "Clear Highlight" },
      { "<leader>x<cr>", function() require("iron.core").send(nil, string.char(13)) end, desc = "ENTER" },
      { "<leader>xI", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt" },
      { "<leader>xC", function() require("iron.core").close_repl() end, desc = "Close REPL" },
      { "<leader>xc", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear" },
      { "<leader>xms", function() require("iron.core").send_mark() end, desc = "Send Mark" },
      { "<leader>xmm", function() require("iron.core").run_motion("mark_motion") end, desc = "Mark Motion" },
      { "<leader>xmv", function() require("iron.core").mark_visual() end, mode = {"v"}, desc = "Mark Visual" },
      { "<leader>xmr", function() require("iron.marks").drop_last() end, desc = "Remove Mark" },
      { "<leader>xR", "<cmd>IronRepl<cr>", desc = "REPL" },
      { "<leader>xS", "<cmd>IronRestart<cr>", desc = "Restart" },
      { "<leader>xF", "<cmd>IronFocus<cr>", desc = "Focus" },
      { "<leader>xH", "<cmd>IronHide<cr>", desc = "Hide" },
    },
    config = function(_, opts)
      local iron = require "iron.core"
      iron.setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>x"] = { name = "+REPL" },
        ["<leader>xm"] = { name = "+Mark" },
      },
    },
  },
  {
    "anuvyklack/hydra.nvim",
    opts = {
      specs = {
        repl = repl_menu,
      },
    },
  },
}
