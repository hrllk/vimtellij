------------------------------
-- Java LSP
-- configure Java language tooling and debugging support
------------------------------
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
}
