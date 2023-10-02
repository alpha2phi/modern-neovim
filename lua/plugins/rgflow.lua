return {
  "mangelozzi/nvim-rgflow.lua",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("rgflow").setup {
      default_trigger_mappings = true,
      default_ui_mappings = true,
      default_quickfix_mappings = true,

      -- WARNING !!! Glob for '-g *{*}' will not use .gitignore file: https://github.com/BurntSushi/ripgrep/issues/2252
      cmd_flags = (
        "--smart-case -g *.{*,py} -g !*.{min.js,pyc} --fixed-strings --no-fixed-strings --no-ignore -M 500"
        -- Exclude globs
        .. " -g !**/.angular/"
        .. " -g !**/node_modules/"
        .. " -g !**/static/*/jsapp/"
        .. " -g !**/static/*/wcapp/"
      ),
    }
  end,
}
