vim.cmd [[:amenu 10.100 Alpha2phi.Definition <cmd>:Telescope lsp_defintions<CR>]]
vim.cmd [[:amenu 10.110 Alpha2phi.Peek\ Definition <cmd>:Lspsaga peek_definition<CR>]]
vim.cmd [[:amenu 10.120 Alpha2phi.Type\ Definition <cmd>:Telescope lsp_type_definitions<CR>]]
vim.cmd [[:amenu 10.130 Alpha2phi.Implementations <cmd>:Telescope lsp_implementations<CR>]]
vim.cmd [[:amenu 10.140 Alpha2phi.References <cmd>:Telescope lsp_references<CR>]]
vim.cmd [[:amenu 10.150 Alpha2phi.-sep- *]]
vim.cmd [[:amenu 10.160 Alpha2phi.Rename <cmd>:Lspsaga rename<CR>]]
vim.cmd [[:amenu 10.170 Alpha2phi.Code\ Actions <cmd>:Lspsaga code_action<CR>]]

vim.keymap.set("n", "<RightMouse>", "<cmd>:popup Alpha2phi<CR>")
vim.keymap.set("n", "<F22>", "<cmd>:popup Alpha2phi<CR>")
