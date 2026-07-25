return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")
      local languages = {
        "vim",
        "vimdoc",
        "lua",
        "java",
        "kotlin",
        "go",
        "gomod",
        "javascript",
        "typescript",
        "html",
        "css",
        "json",
        "tsx",
        "markdown",
        "markdown_inline",
        "gitignore",
        "sql",
        "http",
        "nginx",
        "xml",
      }

      treesitter.setup(opts)
      treesitter.install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        pattern = languages,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
  },
}
