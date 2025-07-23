-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  cmd = {

    -- 💀
    'java',             -- or '/path/to/java21_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx3g',
    '-javaagent:' .. vim.fn.expand('$HOME') .. '/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
    '-jar', vim.fn.expand('$HOME') .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
    '-configuration', vim.fn.expand('$HOME') .. '/.local/share/nvim/mason/packages/jdtls/config_mac_arm',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    -- '-data', '/path/to/unique/per/project/workspace/folder'
    -- '-data', vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

    -- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
    -- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    -- local workspace_dir = '/Users/alzar/.cache/jdtls_workspace/' .. project_name
    -- '-data', workspace_dir,
    '-data', vim.fn.stdpath('cache') .. '/jdtls_workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  },
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
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
