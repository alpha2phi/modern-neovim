return {
  {
    "echasnovski/mini.map",
    opts = {},
    keys = {
      --stylua: ignore
      { "<leader>vm", function() require("mini.map").toggle {} end, desc = "Toggle Minimap", },
    },
    config = function(_, opts)
      require("mini.map").setup(opts)
    end,
  },
  -- {
  --   "echasnovski/mini.jump",
  --   opts = {},
  --   keys = { "f", "F", "t", "T" },
  --   config = function(_, opts)
  --     require("mini.jump").setup(opts)
  --   end,
  -- },
  -- {
  --   "echasnovski/mini.move",
  --   enabled = false,
  --   opts = {},
  --   keys = { "<<M-h>", "<M-l>", "<M-j>", "<M-k>" },
  --   config = function(_, opts)
  --     require("mini.move").setup(opts)
  --   end,
  -- },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      if require("utils").has "which-key.nvim" then
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs { n = "Next", l = "Last" } do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register {
          mode = { "o", "x" },
          i = i,
          a = a,
        }
      end
    end,
  },
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>br", "<cmd>e!<cr>", desc = "Reload Buffer" },
      { "<leader>bc", "<cmd>close<cr>", desc = "Close Buffer" },
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    enabled = false,
    config = function(_, _)
      require("mini.animate").setup()
    end,
  },
  -- {
  --   "echasnovski/mini.comment",
  --   event = "VeryLazy",
  --   opts = {
  --     hooks = {
  --       pre = function()
  --         require("ts_context_commentstring.internal").update_commentstring {}
  --       end,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("mini.comment").setup(opts)
  --   end,
  -- },
  -- {
  --   "echasnovski/mini.pairs",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "echasnovski/mini.misc",
    config = true,
    --stylua: ignore
    keys = {
      { "<leader>vz", function() require("mini.misc").zoom() end, desc = "Toggle Zoom" },
    },
  },
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    config = function()
      require("mini.bracketed").setup()
    end,
  },
  {
    "echasnovski/mini.files",
    opts = {
      windows = {
        preview = true,
        width_nofocus = 30,
        width_preview = 60,
      },
      options = {
        use_as_default_explorer = true,
      },
    },
    keys = {
      {
        "<leader>fE",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Explorer (Current File)",
      },
      {
        "<leader>fe",
        function()
          require("mini.files").open(vim.loop.cwd(), true)
        end,
        desc = "Explorer (Current Directory)",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          local mini_utils = require "plugins.mini.utils"
          local map_split = mini_utils.map_split
          local keymap = vim.keymap

          -- Split view
          map_split(buf_id, "gs", "belowright horizontal")
          map_split(buf_id, "gv", "belowright vertical")

          -- File actions
          keymap.set("n", "g.", mini_utils.toggle_dotfiles, { buffer = buf_id, desc = "Hidden Files" })
          keymap.set("n", "s", mini_utils.jump, { buffer = buf_id, desc = "Jump" })
          keymap.set("n", "M", function()
            mini_utils.file_actions(buf_id)
          end, { buffer = buf_id, desc = "File Actions" })
          keymap.set("n", "m", function()
            mini_utils.folder_actions(buf_id)
          end, { buffer = buf_id, desc = "Folder Actions" })
        end,
      })
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = function()
      local hi = require "mini.hipatterns"
      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color { priority = 2000 },
        },
      }
    end,
  },
  {
    "echasnovski/mini.clue",
    cond = function()
      return require("config").keymenu.mini_clue
    end,
    event = "VeryLazy",
    opts = function()
      local map_leader = function(suffix, rhs, desc)
        vim.keymap.set({ "n", "x" }, "<Leader>" .. suffix, rhs, { desc = desc })
      end
      map_leader("w", "<cmd>update!<CR>", "Save")
      map_leader("qq", require("utils").quit, "Quit")
      map_leader("qt", "<cmd>tabclose<cr>", "Close Tab")
      map_leader("sc", require("utils.coding").cht, "Cheatsheets")
      map_leader("so", require("utils.coding").stack_overflow, "Stack Overflow")

      local miniclue = require "mini.clue"
      return {
        window = {
          delay = vim.o.timeoutlen,
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          { mode = "n", keys = "<Leader>a", desc = "+AI" },
          { mode = "x", keys = "<Leader>a", desc = "+AI" },
          { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
          { mode = "n", keys = "<Leader>d", desc = "+Debug" },
          { mode = "x", keys = "<Leader>d", desc = "+Debug" },
          { mode = "n", keys = "<Leader>D", desc = "+Database" },
          { mode = "n", keys = "<Leader>f", desc = "+File" },
          { mode = "n", keys = "<Leader>h", desc = "+Help" },
          { mode = "n", keys = "<Leader>j", desc = "+Jump" },
          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "x", keys = "<Leader>g", desc = "+Git" },
          { mode = "n", keys = "<Leader>gh", desc = "+Hunk" },
          { mode = "x", keys = "<Leader>gh", desc = "+Hunk" },
          { mode = "n", keys = "<Leader>gt", desc = "+Toggle" },
          { mode = "n", keys = "<Leader>n", desc = "+Notes" },
          { mode = "n", keys = "<Leader>l", desc = "+Language" },
          { mode = "x", keys = "<Leader>l", desc = "+Language" },
          { mode = "n", keys = "<Leader>lg", desc = "+Annotation" },
          { mode = "n", keys = "<Leader>lx", desc = "+Swap Next" },
          { mode = "n", keys = "<Leader>lxf", desc = "+Function" },
          { mode = "n", keys = "<Leader>lxp", desc = "+Parameter" },
          { mode = "n", keys = "<Leader>lxc", desc = "+Class" },
          { mode = "n", keys = "<Leader>lX", desc = "+Swap Previous" },
          { mode = "n", keys = "<Leader>lXf", desc = "+Function" },
          { mode = "n", keys = "<Leader>lXp", desc = "+Parameter" },
          { mode = "n", keys = "<Leader>lXc", desc = "+Class" },
          { mode = "n", keys = "<Leader>p", desc = "+Project" },
          { mode = "n", keys = "<Leader>q", desc = "+Quit/Session" },
          { mode = "x", keys = "<Leader>q", desc = "+Quit/Session" },
          { mode = "n", keys = "<Leader>r", desc = "+Refactor" },
          { mode = "x", keys = "<Leader>r", desc = "+Refactor" },
          { mode = "n", keys = "<Leader>s", desc = "+Search" },
          { mode = "x", keys = "<Leader>s", desc = "+Search" },
          { mode = "n", keys = "<Leader>t", desc = "+Test" },
          { mode = "n", keys = "<Leader>tN", desc = "+Neotest" },
          { mode = "n", keys = "<Leader>to", desc = "+Overseer" },
          { mode = "n", keys = "<Leader>v", desc = "+View" },
          { mode = "n", keys = "<Leader>z", desc = "+System" },

          -- Submodes
          { mode = "n", keys = "<Leader>tNF", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNL", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNa", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNf", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNl", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNn", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNN", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNo", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNs", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNS", postkeys = "<Leader>tN" },

          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows {
            submode_move = false,
            submode_navigate = false,
            submode_resize = true,
          },
          miniclue.gen_clues.z(),
        },
      }
    end,
  },
  {
    "echasnovski/mini.operators",
    event = "VeryLazy",
    opts = {
      -- Evaluate text and replace with output
      evaluate = {
        prefix = "g=",
        func = nil,
      },

      -- Exchange text regions
      exchange = {
        prefix = "gX",
        reindent_linewise = true,
      },

      -- Multiply (duplicate) text
      multiply = {
        prefix = "gm",
      },

      -- Replace text with register
      replace = {
        prefix = "gR",
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = "gs",
        func = nil,
      },
    },
  },
  { "echasnovski/mini.pick", opts = {}, cmd = { "Pick" }, enabled = false },
}
