return {


    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            -- ensure that we have lua language server, typescript launguage server, java language server, and java test language server are installed
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "jdtls"}, -- mason registry needs
            })
        end
    },

    -- LspInfo, LspLog
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- get access to the lspconfig plugins functions

            local lspconfig = require("lspconfig")

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- setup the lua language server
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })

            -- setup the typescript language server
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            vim.keymap.set("n", "<leader>O", ":lua vim.lsp.buf.code_action()<CR>")
            vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
            vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
            vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
            vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
            vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
            vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
            vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>")

            -- Set vim motion for <Space> + c + h to show code documentation about the code the cursor is currently over if available
            -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
            -- -- Set vim motion for <Space> + c + d to go where the code/variable under the cursor was defined
            -- vim.keymap.set("n", "gI", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
            -- -- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
            -- vim.keymap.set({ "n", "v" }, "<leader>O", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
            -- Set vim motion for <Space> + c + r to display references to the code under the cursor
            -- vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
            -- -- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
            -- vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations" })
            -- -- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
            -- vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
            -- -- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
            -- vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
        end
    },

    {
        "mfussenegger/nvim-jdtls",
        -- dependencies = {
        --     "mfussenegger/nvim-dap",
        -- },
        config = function()

            -- add condition to active when only java project or spring project 

            local function is_java_or_spring_project()
                local has_pom = vim.fn.filereadable('pom.xml') == 1
                local has_gradle = vim.fn.filereadable('build.gradle') == 1
                local has_java_src = vim.fn.isdirectory('src/main/java') == 1
                return has_pom or has_gradle or has_java_src
            end

            if is_java_or_spring_project() then
                require('jdtls').start_or_attach({
                      cmd = {

                        -- 💀
                        'java', -- or '/path/to/java21_or_newer/bin/java'
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
                  root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew"}),
                  settings = {
                    java = {
                    }
                  },
                  init_options = {
                    bundles = {}
                  },
            })
        end
    end
    }
}
