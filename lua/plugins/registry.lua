return {
    -- {
    --     "williamboman/mason.nvim",
    --     config = function()
    --         -- setup mason with default properties
    --         require("mason").setup()
    --     end
    -- },

  'williamboman/mason.nvim',
  opts = {
    registries = {
      'github:nvim-java/mason-registry',
      'github:mason-org/mason-registry',
    },
  },
}
