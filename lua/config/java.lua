-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx2g',
    '-javaagent:/Users/hwiryungkim/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    -- '-jar', vim.fn.glob('/Users/hwiryungkim/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-jar', '/Users/hwiryungkim/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',
    '-configuration', '/Users/hwiryungkim/.local/share/nvim/mason/packages/jdtls/config',
    '-data', vim.fn.stdpath('cache') .. '/jdtls_workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  },
  root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew"}),
  settings = {
    java = {
    }
  },
  init_options = {
    bundles = {}
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

