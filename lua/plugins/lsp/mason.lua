------------------------------
-- Mason registry
-- configure registries for external development tools
------------------------------
return {
  "williamboman/mason.nvim",
  opts = {
    registries = {
      "github:nvim-java/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
}
