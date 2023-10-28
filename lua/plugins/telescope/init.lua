return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "ahmedkhalf/project.nvim",
      "cljoly/telescope-repo.nvim",
      "stevearc/aerial.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "kkharji/sqlite.lua",
      "aaronhallaert/advanced-git-search.nvim",
      "benfowler/telescope-luasnip.nvim",
      "olacin/telescope-cc.nvim",
      "tsakirist/telescope-lazy.nvim",
      "tiagovla/scope.nvim",
      {
        "ecthelionvi/NeoComposer.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        enabled = false,
        opts = {},
      },
      "jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      { "<leader><space>", require("utils").find_files, desc = "Find Files" },
      { "<leader>ff", require("utils").telescope("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fF", require("utils").telescope("files", { cwd = false }), desc = "Find Files (Cwd)" },
      { "<leader>gf", require("plugins.telescope.pickers").git_diff_picker, desc = "Diff Files" },
      { "<leader>fo", "<cmd>Telescope frecency theme=dropdown previewer=false<cr>", desc = "Recent" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>", desc = "Buffers" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fc", "<cmd>cd %:p:h<cr>", desc = "Change WorkDir" },
      { "<leader>fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Live Grep", },
      { "<leader>fr", "<cmd>Telescope file_browser<cr>", desc = "Browser" },
      { "<leader>fz", "<cmd>Telescope zoxide list<cr>", desc = "Recent Folders" },
      { "<leader>gc", "<cmd>Telescope conventional_commits<cr>", desc = "Conventional Commits" },
      { "<leader>zs", "<cmd>Telescope lazy<cr>", desc = "Search Plugins" },
      { "<leader>ps", "<cmd>Telescope repo list<cr>", desc = "Search" },
      { "<leader>hs", "<cmd>Telescope help_tags<cr>", desc = "Search" },
      { "<leader>pp", function() require("telescope").extensions.project.project { display_type = "minimal" } end, desc = "List", },
      { "<leader>sw", require("utils").telescope("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sW", require("utils").telescope("live_grep", { cwd = false }), desc = "Grep (Cwd)" },
      { "<leader>ss", "<cmd>Telescope luasnip<cr>", desc = "Snippets" },
      { "<leader>sb", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Buffer", },
      { "<leader>vo", "<cmd>Telescope aerial<cr>", desc = "Code Outline" },
      { "<leader>zc", function() require("telescope.builtin").colorscheme({enable_preview = true}) end, desc = "Colorscheme", },
      { "<leader>su", function() require("telescope.builtin").live_grep({ search_dirs = {vim.fs.dirname(vim.fn.expand("%")) }}) end , desc = "Grep (Current File Path)" },
    },
    config = function(_, _)
      local telescope = require "telescope"
      local icons = require "config.icons"
      local actions = require "telescope.actions"
      local actions_layout = require "telescope.actions.layout"
      local transform_mod = require("telescope.actions.mt").transform_mod
      local custom_pickers = require "plugins.telescope.pickers"
      local custom_actions = transform_mod {

        -- File path
        file_path = function(prompt_bufnr)
          -- Get selected entry and the file full path
          local content = require("telescope.actions.state").get_selected_entry()
          local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

          -- Yank the path to unnamed and clipboard registers
          vim.fn.setreg('"', full_path)
          vim.fn.setreg("+", full_path)

          -- Close the popup
          vim.notify "File path is yanked "
          require("telescope.actions").close(prompt_bufnr)
        end,

        -- Change directory
        cwd = function(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          local dir = vim.fn.fnamemodify(selection.path, ":p:h")
          require("telescope.actions").close(prompt_bufnr)
          -- Depending on what you want put `cd`, `lcd`, `tcd`
          vim.cmd(string.format("silent lcd %s", dir))
        end,

        -- VisiData
        visidata = function(prompt_bufnr)
          -- Get the full path
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end
          local file_path = ""
          if content.filename then
            file_path = content.filename
          elseif content.value then
            if content.cwd then
              file_path = content.cwd
            end
            file_path = file_path .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open the file with VisiData
          local utils = require "utils"
          utils.open_term("vd " .. file_path, { direction = "float" })
        end,

        -- File browser
        file_browser = function(prompt_bufnr)
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end

          local file_dir = ""
          if content.filename then
            file_dir = vim.fs.dirname(content.filename)
          elseif content.value then
            if content.cwd then
              file_dir = content.cwd
            end
            file_dir = file_dir .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open file browser
          -- vim.cmd("Telescope file_browser select_buffer=true path=" .. vim.fs.dirname(full_path))
          require("telescope").extensions.file_browser.file_browser { select_buffer = true, path = file_dir }
        end,

        -- Toggleterm
        toggle_term = function(prompt_bufnr)
          -- Get the full path
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end

          local file_dir = ""
          if content.filename then
            file_dir = vim.fs.dirname(content.filename)
          elseif content.value then
            if content.cwd then
              file_dir = content.cwd
            end
            file_dir = file_dir .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open terminal
          local utils = require "utils"
          utils.open_term(nil, { direction = "float", dir = file_dir })
        end,
      }

      local mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["?"] = actions_layout.toggle_preview,
          ["<C-s>"] = custom_actions.visidata,
          ["<A-f>"] = custom_actions.file_browser,
          ["<C-z>"] = custom_actions.toggle_term,
        },
        n = {
          ["s"] = custom_actions.visidata,
          ["z"] = custom_actions.toggle_term,
          ["<A-f>"] = custom_actions.file_browser,
          ["q"] = require("telescope.actions").close,
          ["cd"] = custom_actions.cwd,
        },
      }

      local opts = {
        defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          mappings = mappings,
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          path_display = { "truncate" },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
          },
          live_grep = {
            mappings = {
              i = {
                ["<c-f>"] = custom_pickers.actions.set_extension,
                ["<c-l>"] = custom_pickers.actions.set_folders,
              },
            },
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown",
            previewer = false,
            hijack_netrw = false,
            mappings = mappings,
          },
          project = {
            hidden_files = false,
            theme = "dropdown",
          },
        },
      }
      telescope.setup(opts)
      telescope.load_extension "fzf"
      telescope.load_extension "file_browser"
      telescope.load_extension "project"
      telescope.load_extension "projects"
      telescope.load_extension "aerial"
      telescope.load_extension "dap"
      telescope.load_extension "frecency"
      telescope.load_extension "luasnip"
      telescope.load_extension "conventional_commits"
      telescope.load_extension "lazy"
      telescope.load_extension "noice"
      telescope.load_extension "notify"
      telescope.load_extension "zoxide"
      telescope.load_extension "live_grep_args"
      telescope.load_extension "scope"

      -- Highlights
      local fg_bg = require("utils").fg_bg
      local colors = require "plugins.colorscheme.colors"
      fg_bg("TelescopePreviewTitle", colors.black, colors.green)
      fg_bg("TelescopePromptTitle", colors.black, colors.red)
      fg_bg("TelescopeResultsTitle", colors.darker_black, colors.blue)
    end,
  },
  {
    "stevearc/aerial.nvim",
    config = true,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git" },
        ignore_lsp = { "null-ls" },
      }
    end,
  },
}
