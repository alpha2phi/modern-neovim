local opt = vim.opt

opt.formatoptions = "jcroqlnt" -- tcqj
opt.shortmess:append { W = true, I = true, c = true }
opt.breakindent = true
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.cmdheight = 1
opt.completeopt = "menuone,noselect"
opt.conceallevel = 3
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.foldcolumn = "1" -- '0' is not bad
opt.foldenable = true
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.hidden = true
opt.hlsearch = false
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.joinspaces = false
opt.laststatus = 0
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
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.title = true
opt.undofile = true
opt.updatetime = 200
opt.wildmode = "longest:full,full"

if vim.fn.has "nvim-0.9.0" == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append { C = true }
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
