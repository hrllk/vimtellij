# Plugins

All 36 plugin specs this configuration declares, what each one is configured to
do, and when `lazy.nvim` loads it.

`lazy-lock.json` pins 52 plugins. The difference is dependencies: a spec like
`nvim-cmp` pulls in `cmp-buffer` and `cmp-path`, which are locked but never
declared as top-level specs.

## Reading the load trigger

| Trigger | Meaning |
| --- | --- |
| `lazy = false` | Loaded during startup, always. |
| `priority = N` | Among `lazy = false` specs, higher loads first. Default is 50. |
| `event = "X"` | Loaded the first time autocmd event `X` fires. |
| `ft = "X"` | Loaded when a buffer of filetype `X` opens. |
| `cmd = "X"` | Loaded when you first run `:X`. |
| `keys = {...}` | Loaded when you first press one of those keys. |
| (none) | Loaded on `VimEnter`, after startup. |

`VeryLazy` is a `lazy.nvim` event that fires once the UI is up and the first
file is on screen. It is the usual choice for anything not needed to draw the
first frame.

## Startup-critical

These load during startup because they paint the first screen.

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `folke/tokyonight.nvim` | `lazy = false`, `priority = 1000` | Colorscheme `tokyonight-night`, `transparent = true`. Its `on_highlights` sets 19 highlight groups: blanking backgrounds and coloring code-block borders from the palette. Its `config` then reapplies Markdown and terminal highlights on `ColorScheme` and `VimEnter`. See [Theme and colors](theme-and-colors.md). |
| `folke/snacks.nvim` | `lazy = false`, `priority = 1000` | Explorer, picker, dashboard, Lazygit, Git pickers, and 15 keymaps. Options come from `require("config.snacks").setup()`. Its `init` disables Snacks animations and adds a bundled `rg` to `PATH` when the shell's `rg` is not inherited (GUI launches). |
| `nvim-treesitter/nvim-treesitter` | `lazy = false` | Installs 20 parsers into `stdpath("data")/site` and starts highlighting via a `FileType` autocmd. See [LSP and tools](lsp-and-tools.md#treesitter). |
| `folke/noice.nvim` | `lazy = false` | Replaces the command line and message UI. Adds a route that swallows the "No information available" notification and turns on the `lsp_doc_border` preset. |
| `folke/which-key.nvim` | `lazy = false` | Popup that lists what a pending key prefix can do. `<leader>?` shows buffer-local maps only. |
| `hrllk/showkeys` | `lazy = false` | On-screen display of the last 3 keys pressed, `auto_start = true`, 1200 ms timeout, borderless window at the top-left. |

`tokyonight` and `snacks` share `priority = 1000`, so their relative order is not
guaranteed. Neither depends on the other having run, and both reapply their
highlights on `ColorScheme`, which is why the ordering does not matter here.

## Editor behavior

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `kevinhwang91/nvim-ufo` | `VeryLazy` | Fold preview and persistence. `provider_selector` returns `""`, which disables UFO's own fold providers and leaves `foldmethod = manual` in charge. A custom `fold_virt_text_handler` appends ` 󰁂 N` with the folded line count. The `config` block also owns `mkview` persistence, the Markdown sidecar, and the `zf` / `zo` Markdown mappings. See [Fold persistence](../explanation/fold-persistence.md). |
| `nvimtools/none-ls.nvim` | (none) | Bridges external formatters and linters into the LSP client. Three sources: `stylua` (Lua formatting), `prettier` (formatting), `eslint_d` (diagnostics, via `none-ls-extras`). Binds `<leader>cf`. |
| `windwp/nvim-autopairs` | `InsertEnter` | Auto-closes brackets and quotes. `check_ts = true` consults Treesitter so it skips inside Lua strings and JS template strings. Disabled entirely for Java. Hooks `nvim-cmp`'s `confirm_done` so completing a function adds its parentheses. |
| `windwp/nvim-ts-autotag` | `BufReadPre`, `BufNewFile` | Closes and renames HTML-like tags. Close-on-slash is off. |
| `ThePrimeagen/harpoon` | `VeryLazy` | Marks files for instant switching. `<leader>a` marks, `<C-e>` opens the menu. |
| `mbbill/undotree` | (none) | Visual undo history. `<leader>u` toggles. |
| `smjonas/inc-rename.nvim` | `cmd = "IncRename"`, `keys` | LSP rename with live preview of every edit. `<leader>rn` prefills the word under the cursor. |
| `folke/todo-comments.nvim` | `VeryLazy` | Highlights `TODO`, `FIX`, `HACK`, `WARN`, `PERF`, `NOTE`, `TEST` and their aliases, with signs at priority 8. |
| `christoomey/vim-tmux-navigator` | (none) | `<C-h/j/k/l>` moves between Neovim windows and tmux panes with one keymap set. |
| `VPavliashvili/json-nvim` | `ft = "json"` | JSON format and minify commands. |
| `echasnovski/mini.hipatterns` | `BufReadPre` | Highlights patterns inline. Default options, so hex color codes render in their own color. |

## Markdown

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `MeanderingProgrammer/render-markdown.nvim` | (none) | In-buffer Markdown rendering. Two customizations: HTML comments are not concealed, and six custom checkbox states are defined. `custom_handlers` comes from `config.markdown_task_scope`, which extends the `[~]` dim over the item's whole subtree. |
| `iamcco/markdown-preview.nvim` | `ft = "markdown"`, `cmd` | Browser preview. Its `build` runs `yarn install` in the plugin's `app/` directory, then downloads Mermaid 11 from jsDelivr over the bundled copy, once per session (`vim.g.__markdown_preview_mermaid_patched`). Runs again in `config` so a plugin update does not silently revert Mermaid. |

### Checkbox states

Defined in `lua/plugins/editor/markdown.lua`. `[ ]` and `[x]` are Markdown
grammar and work without being listed.

| Raw | Rendered | Highlight | Meaning |
| --- | --- | --- | --- |
| `[-]` | 󰥔 | `RenderMarkdownTodo` | Todo |
| `[>]` | 󰦖 | `DiagnosticWarn` | Waiting |
| `[/]` | 󰦕 | `DiagnosticInfo` | In progress |
| `[!]` | 󰗖 | `DiagnosticError` | Blocked |
| `[?]` | 󰘥 | `DiagnosticHint` | Question |
| `[~]` | 󰅘 | `Comment` | Cancelled |

`raw` is matched lowercase and needs a space after the bracket. Only `[~]` dims
its sub-items; the other five color the marker alone.

## LSP and completion

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `neovim/nvim-lspconfig` | (none) | Configures and enables `lua_ls`, `gopls`, `marksman`, plus `ts_ls` when `typescript-language-server` is on `PATH`. Depends on `mason.nvim` so Mason's bin directory is on `PATH` before the `executable()` probe runs. |
| `williamboman/mason.nvim` | (none) | Installer for language servers and tools. Registers the `nvim-java` registry ahead of the default one, which is where the JDTLS and Lombok packages come from. |
| `williamboman/mason-lspconfig.nvim` | `VeryLazy` | Auto-installs `gopls`, `lua_ls`, `marksman`, `ts_ls`. Note `jdtls` is absent: Java is started by `ftplugin/java.lua` instead. |
| `mfussenegger/nvim-jdtls` | `ft = "java"` | Java language server client, driven by `ftplugin/java.lua`. Pulls in `nvim-dap` for debugging. |
| `hrsh7th/nvim-cmp` | `InsertEnter` | Completion engine. Four sources in priority order: LSP, LuaSnip, buffer, path. Never preselects. See below. |
| `L3MON4D3/LuaSnip` | `InsertEnter` | Snippet engine. Lazy-loads the `friendly-snippets` VS Code templates. |
| `hrsh7th/cmp-nvim-lsp` | (none) | Advertises `nvim-cmp`'s capabilities to servers. Required by `lspconfig` and `ftplugin/java.lua`. |
| `supermaven-inc/supermaven-nvim` | `InsertEnter` | Inline AI suggestions. Default options. |

### Completion tuning

| Setting | Default | Java |
| --- | --- | --- |
| Characters before completion triggers | 2 | 3 |
| Max visible entries | 40 | 40 |
| LSP result cap | unlimited | 30, with `Text` kind filtered out |
| Buffer source | any length | 4 characters, max 8 entries |
| Debounce / throttle | 80 ms / 30 ms | same |
| Fetch timeout | 200 ms | same |

Java gets tighter limits because JDTLS returns very large candidate sets on a
big classpath. Source: `lua/plugins/lsp/completion.lua`.

## Git

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `lewis6991/gitsigns.nvim` | `BufReadPre` | Change signs in the gutter, hunk navigation, staging, blame, diff. Signs use `▎` for add, change, changedelete, and untracked; `` for delete and topdelete. Its `on_attach` sets 16 buffer-local mappings. |
| `hrllk/file-line-range-history` | `keys` | Git history for a visually selected line range, in a rounded float at 90% by 85%. Treesitter-aware. Its own keymap is disabled (`keymap = false`) so the spec's `<leader>gflh` is the only binding. |

## UI

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `nvim-lualine/lualine.nvim` | `UIEnter` | Statusline. `theme = "auto"`, no separators, `globalstatus = false` so each window gets its own. Refreshes on 10 events at up to 100 ms. |
| `nanozuki/tabby.nvim` | (none) | Tabline with the `tab_only` preset: tab labels on the left, no per-window or per-file labels. |
| `b0o/incline.nvim` | `BufReadPre`, `priority = 1200` | Floating filename label in each window's top corner. Shows the filetype icon on its own color, and italicizes the name when the buffer is modified. |
| `rcarriga/nvim-notify` | (none) | Notification popups. 5 s timeout, `wrapped-compact` render, background from `colors.terminal`. |
| `nvim-zh/colorful-winsep.nvim` | `VeryLazy` | Colors the separator around the active window. Uses `colors.accent` when Neovim has focus and `colors.inactive` when it does not, tracked through `FocusLost` and `FocusGained`. |

## Other

| Plugin | Trigger | What it is configured to do |
| --- | --- | --- |
| `kristijanhusak/vim-dadbod-ui` | `cmd`, `keys` | Database browser and SQL runner. Nerd Font icons on, 40-column tree. Its `init` adds buffer-local `-` and `=` resizing for `dbui`, `dbout`, and DBUI-owned `sql` buffers, and sizes a new result window to half the screen. Depends on `vim-dadbod` and `vim-dadbod-completion`. |
| `rest-nvim/rest.nvim` | (none) | Sends HTTP requests from a `.http` buffer. Appends the `http` parser to the Treesitter install list. `rr` runs the request under the cursor. |

## Adding to this list

See [How to add a plugin](../how-to/add-a-plugin.md). The one thing that is easy
to miss: a brand-new directory under `lua/plugins/` needs a matching
`{ import = ... }` line in `init.lua`, or its specs are silently ignored.

## Related

- [Architecture](../explanation/architecture.md) — why the specs are grouped this way
- [Keymaps](keymaps.md) — every mapping these plugins bind
- [LSP and tools](lsp-and-tools.md)
- [Theme and colors](theme-and-colors.md)
