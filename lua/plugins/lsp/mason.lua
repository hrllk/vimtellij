------------------------------
-- Mason registry
-- configure registries for external development tools
------------------------------
return {
  "williamboman/mason.nvim",
  opts = {
    -- nvim-java's registry comes first on purpose: it supplies the jdtls and
    -- lombok-nightly packages that ftplugin/java.lua resolves by hand at
    -- ~/.local/share/nvim/mason/packages/{jdtls,lombok-nightly}. Sorting or
    -- deduping this list breaks Java startup.
    registries = {
      "github:nvim-java/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
}
