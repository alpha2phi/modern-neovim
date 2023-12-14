local function popup_editor()
  require("detour").Detour()
  vim.cmd.enew()
  vim.bo.bufhidden = "delete"
end

return {
  "carbon-steel/detour.nvim",
  enabled = false,
  cmd = { "Detour" },
  keys = {
    { "<leader>zt", popup_editor, desc = "Popup Editor" },
  },
}
