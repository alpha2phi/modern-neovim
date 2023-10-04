return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        enabled = false,
      },
      { "jcdickinson/codeium.nvim", config = true, enabled = false },
      {
        "jcdickinson/http.nvim",
        build = "cargo build --workspace --release",
        enabled = false,
      },
    },
    opts = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local neogen = require "neogen"
      local icons = require "config.icons"
      local compare = require "cmp.config.compare"
      local source_names = {
        nvim_lsp = "(LSP)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
        path = "(Path)",
      }
      local duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      }
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.score,
            compare.recently_used,
            compare.offset,
            compare.exact,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping {
            i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            end,
          },
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif neogen.jumpable() then
              neogen.jump_next()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            "i",
            "s",
            "c",
          }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif neogen.jumpable(true) then
              neogen.jump_prev()
            else
              fallback()
            end
          end, {
            "i",
            "s",
            "c",
          }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", group_index = 1, max_item_count = 15 },
          { name = "codeium", group_index = 1 },
          { name = "luasnip", group_index = 1, max_item_count = 8 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "git", group_index = 2 },
          { name = "orgmode", group_index = 2 },
        },
        formatting = {
          format = function(entry, item)
            local max_width = 80
            local duplicates_default = 0
            if max_width ~= 0 and #item.abbr > max_width then
              item.abbr = string.sub(item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
            end
            item.kind = icons.kind[item.kind]
            item.menu = source_names[entry.source.name]
            item.dup = duplicates[entry.source.name] or duplicates_default

            return item
          end,
        },
        window = {
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- Auto pairs
      local has_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if has_autopairs then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
      end

      -- Git
      require("cmp_git").setup { filetypes = { "NeogitCommitMessage" } }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "honza/vim-snippets",
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load()

          -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
          -- are stored in `ls.snippets._`.
          -- We need to tell luasnip that "_" contains global snippets:
          require("luasnip").filetype_extend("all", { "_" })
        end,
      },
    },
    build = "make install_jsregexp",
    opts = function()
      local types = require "luasnip.util.types"
      return {
        history = true,
        delete_check_events = "TextChanged",

        -- Display a cursor-like placeholder in unvisited nodes of the snippet.
        ext_opts = {
          [types.insertNode] = {
            unvisited = {
              virt_text = { { "|", "Conceal" } },
              -- virt_text_pos = "inline",
            },
          },
          [types.exitNode] = {
            unvisited = {
              virt_text = { { "|", "Conceal" } },
              -- virt_text_pos = "inline",
            },
          },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      {
        "<C-j>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<C-j>"
        end,
        expr = true, remap = true, silent = true, mode = "i",
      },
      { "<C-j>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      local snippets_folder = vim.fn.stdpath "config" .. "/lua/plugins/completion/snippets/"
      require("luasnip.loaders.from_lua").lazy_load { paths = snippets_folder }

      vim.api.nvim_create_user_command("LuaSnipEdit", function()
        require("luasnip.loaders.from_lua").edit_snippet_files()
      end, {})
    end,
  },
}
