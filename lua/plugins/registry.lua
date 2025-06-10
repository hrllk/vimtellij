return {
  {
    "williamboman/mason.nvim",
    config = function()
      -- setup mason with default properties
      require("mason").setup()
    end
  },

  -- 'williamboman/mason.nvim',
  -- opts = {
  --   registries = {
  --     'github:nvim-java/mason-registry',
  --     'github:mason-org/mason-registry',
  --   },
  -- },
  --
  -- 'williamboman/mason.nvim',
  -- config = function()
  --     require("mason").setup({
  --       registries = {
  --         'github:nvim-java/mason-registry',
  --         'github:mason-org/mason-registry', -- lombok 설치위한 임시 필요
  --       },
  -- })
  -- end

}
