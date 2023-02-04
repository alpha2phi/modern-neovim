return {
  "danymat/neogen",
  opts = {
    snippet_engine = "luasnip",
    enabled = true,
    languages = {
      lua = {
        template = {
          annotation_convention = "ldoc",
        },
      },
      python = {
        template = {
          annotation_convention = "google_docstrings",
        },
      },
      rust = {
        template = {
          annotation_convention = "rustdoc",
        },
      },
      javascript = {
        template = {
          annotation_convention = "jsdoc",
        },
      },
      typescript = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
      typescriptreact = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
    },
  },
  --stylua: ignore
  keys = {
    { "<leader>cgd", function() require("neogen").generate() end, desc = "Annotation", },
    { "<leader>cgc", function() require("neogen").generate { type = "class" } end, desc = "Class", },
    { "<leader>cgf", function() require("neogen").generate { type = "func" } end, desc = "Function", },
    { "<leader>cgt", function() require("neogen").generate { type = "type" } end, desc = "Type", },
  },
}
