local opt = vim.opt

opt.autoindent = true
opt.breakindent = true
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.cmdheight = 0
opt.completeopt = "menuone,noselect"
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.foldcolumn = "1" -- '0' is not bad
opt.foldenable = true
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.formatoptions = "jqlnt" -- tcqj
opt.hidden = true
opt.hlsearch = false
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.joinspaces = false
opt.laststatus = 3
opt.list = true
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.scrollback = 100000
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showcmd = false
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.title = true
opt.undofile = true
opt.updatetime = 200
opt.wildmode = "longest:full,full"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.markdown_recommended_style = 0

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local function update_lead()
  local lcs = vim.opt_local.listchars:get()
  local tab = vim.fn.str2list(lcs.tab)
  local space = vim.fn.str2list(lcs.multispace or lcs.space)
  local lead = { tab[1] }
  for i = 1, vim.bo.tabstop - 1 do
    lead[#lead + 1] = space[i % #space + 1]
  end
  vim.opt_local.listchars:append { leadmultispace = vim.fn.list2str(lead) }
end

local function indent_listchars()
  opt.list = true
  opt.listchars = {
    tab = "⟩ ",
    trail = "+",
    precedes = "<",
    extends = ">",
    space = "·",
    nbsp = "␣",
    leadmultispace = "│ ",
    multispace = "│ ",
  }
  vim.api.nvim_create_autocmd("OptionSet", { pattern = { "listchars", "tabstop", "filetype" }, callback = update_lead })
  vim.api.nvim_create_autocmd("VimEnter", { callback = update_lead, once = true })
end
