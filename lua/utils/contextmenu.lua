vim.cmd [[:amenu 90.100 Alpha2phi.Definition <cmd>:Telescope lsp_defintions<CR>]]
vim.cmd [[:amenu 90.100 Alpha2phi.Type\ Definition <cmd>:Telescope lsp_type_definitions<CR>]]
vim.cmd [[:amenu 90.100 Alpha2phi.Implementations <cmd>:Telescope lsp_implementations<CR>]]
vim.cmd [[:amenu 90.100 Alpha2phi.References <cmd>:Telescope lsp_references<CR>]]
vim.cmd [[:amenu 90.100 Alpha2phi.-1- *]]
vim.cmd [[:amenu 90.100 Alpha2phi.Rename <cmd>:Lspsaga rename<CR>]]
vim.cmd [[:amenu 90.100 Alpha2phi.Code\ Actions <cmd>:Lspsaga code_action<CR>]]

vim.keymap.set("n", "<RightMouse>", "<cmd>:popup Alpha2phi<CR>")
vim.keymap.set("n", "<F22>", "<cmd>:popup Alpha2phi<CR>")
