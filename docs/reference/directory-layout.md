# Directory layout

Every file in this configuration and what it owns. Paths are relative to the
config root (`~/.config/nvim`).

## Top level

| Path | Purpose |
| --- | --- |
| `init.lua` | Bootstraps `lazy.nvim`, loads the four `config` modules, then calls `lazy.setup()`. See [Architecture](../explanation/architecture.md). |
| `lazy-lock.json` | Pinned commit for each of the 52 installed plugins. Git-ignored in this repo. |
| `stylua.toml` | Lua formatter settings: 2-space indent, 120-column width. |
| `.luarc.json` | Declares `vim` as a global so `lua_ls` stops flagging it. |
| `.env.example` | API key template for Task Master. Not read by Neovim. |
| `.gitignore` | Ignores `lazy-lock.json`, `nvim.log`, `.gbrain-source`, `.env`, and editor dirs. |
| `README.md` | Project overview and installation. Points here for detail. |
| `LICENSE` | MIT. |

## `lua/config/` — editor-wide settings

Loaded directly by `init.lua`, before any plugin. Nothing here declares a
plugin; these modules run on every startup.

| File | Lines | Purpose |
| --- | --- | --- |
| `options.lua` | 44 | All `vim.opt` settings. See [Options](options.md). |
| `keymaps.lua` | 131 | Leader key and all global mappings. See [Keymaps](keymaps.md). |
| `autocmds.lua` | 36 | Autosave on `InsertLeave`, `FocusLost`, `BufLeave`. |
| `theme.lua` | 19 | Forces the `Visual` / `VisualNOS` background to `#264F78`, reapplied on `ColorScheme`. |
| `colors.lua` | 9 | The shared palette table. Seven keys, no logic. See [Theme and colors](theme-and-colors.md). |

### Feature modules under `lua/config/`

These are libraries. They export functions and are required by a plugin spec,
never loaded on their own.

| File | Lines | Required by | Purpose |
| --- | --- | --- | --- |
| `folding_anchor.lua` | 106 | `folding_sidecar.lua` | Pure text functions: normalize a line, find the Nth occurrence of a text, detect overlapping ranges. No Neovim state. |
| `folding_sidecar.lua` | 184 | `plugins/editor/folding.lua` | Reads and writes the `.<name>.md.folds.json` sidecar next to a Markdown file. |
| `folding_adapter.lua` | 18 | `plugins/editor/folding.lua` | The `zo` behavior for Markdown: open the fold under the cursor and drop its sidecar entry. |
| `markdown_task_scope.lua` | 196 | `plugins/editor/markdown.lua` | Wraps `render-markdown`'s builtin handlers so a `[~]` task dims its entire sub-item subtree, icons included. |
| `snacks_dashboard.lua` | 254 | `plugins/snacks.lua` | Paints the animated `milli` splash frames into the Snacks dashboard buffer and owns the `SnacksDashboard*` highlights. |

Both folding modules are explained in [Fold persistence](../explanation/fold-persistence.md).

### `lua/config/snacks/` — Snacks option fragments

Each file returns a plain table. `init.lua` deep-merges them into one options
table, which `plugins/snacks.lua` passes to `require("snacks").setup()`.

| File | Lines | Returns |
| --- | --- | --- |
| `init.lua` | 14 | `M.setup()`, which merges `{ image = {} }` with the four fragments below. |
| `explorer.lua` | 76 | Explorer source config plus two custom actions: `diff_files` (`D`) and `explorer_toggle_width` (`=`). |
| `picker.lua` | 18 | `hidden` / `ignored` defaults and exclude globs for the `files` and `grep` sources. |
| `dashboard.lua` | 27 | Dashboard preset: `milli` splash header plus four action keys. |
| `lazygit.lua` | 15 | Lazygit window style with line numbers and sign column off. |

Note the two similarly named files: `lua/config/snacks/dashboard.lua` returns
static dashboard *options*, while `lua/config/snacks_dashboard.lua` is the
*runtime animation* module. Both are live; neither is dead code.

## `lua/plugins/` — lazy.nvim specs

One directory per feature area. `init.lua` imports each explicitly, so a new
directory needs a matching `{ import = ... }` line. See
[Architecture](../explanation/architecture.md) for why.

| Path | Specs | Contents |
| --- | --- | --- |
| `snacks.lua` | 1 | `folke/snacks.nvim`. Explorer, picker, dashboard, Lazygit, and 15 `<leader>` keymaps. |
| `integration.lua` | 1 | `rest-nvim/rest.nvim`, an HTTP client. |
| `dbui.lua` | 1 | `vim-dadbod-ui` plus buffer-local `-` / `=` window resizing. |
| `ai/` | 1 | `supermaven-nvim`, inline AI completion on `InsertEnter`. |
| `editor/` | 13 | Folding, formatting, Treesitter, Markdown, autopairs, harpoon, undotree, and more. |
| `git/` | 2 | `gitsigns.nvim` and `hrllk/file-line-range-history`. |
| `lsp/` | 7 | `nvim-lspconfig`, Mason, `nvim-cmp`, LuaSnip, `nvim-jdtls`. |
| `ui/` | 10 | Theme, statusline, tabline, notifications, which-key, Markdown preview. |

Full per-plugin detail is in [Plugins](plugins.md).

`ui/nvim-window-hightlighter.lua` has a typo in its filename (`hightlighter`).
It is spelled that way on disk; renaming it is tracked as a pending Task Master
task.

## `ftplugin/` — filetype-local settings

Neovim sources these automatically when a buffer's `filetype` matches the
filename. No registration needed.

| File | Lines | Effect |
| --- | --- | --- |
| `lua.lua` | 5 | 2-space indent (`tabstop`, `softtabstop`, `shiftwidth`). |
| `javascript.lua` | 5 | 2-space indent. |
| `typescriptreact.lua` | 4 | 2-space indent. |
| `json.lua` | 2 | Sets `formatprg=jq .` so `gq` reformats JSON. |
| `java.lua` | 111 | Starts JDTLS: resolves the Equinox launcher jar, picks a macOS config dir, attaches Lombok, and derives a per-project workspace from a SHA-256 of the root. See [LSP and tools](lsp-and-tools.md). |

## `tests/` — headless specs

Plain Lua scripts run with `nvim --headless -u NONE -l <file>`. They use
`assert`, not a test framework, and are driven by `scripts/check`.

| File | Lines | Covers |
| --- | --- | --- |
| `folding_anchor_spec.lua` | 64 | Anchor normalization, occurrence lookup, overlap detection. |
| `folding_sidecar_spec.lua` | 83 | Sidecar read/write, version validation, entry removal. |
| `folding_adapter_smoke.lua` | 120 | `zo` opens the fold and drops the right entry. |
| `theme_highlight_spec.lua` | 119 | The palette-driven highlight groups resolve as expected. |

## `scripts/`

| File | Purpose |
| --- | --- |
| `check` | Three-stage validation: Lua syntax, full headless config load, then the four test files. Run it before committing. See [How to run checks](../how-to/run-checks.md). |

## `docs/`

| Path | Contents |
| --- | --- |
| `reference/` | This section. What the configuration contains, stated factually. |
| `how-to/` | Task recipes for changing the configuration. |
| `explanation/` | Why the structure is shaped this way. |
| `plans/` | Design documents for work that is not finished yet. |
| `archive/` | Design records for work that shipped. Kept for rationale, not for accuracy. |

## Generated paths outside the repo

The configuration writes to standard Neovim directories, not into this repo.

| Path | Written by |
| --- | --- |
| `stdpath("data")/lazy/` | `lazy.nvim` plugin clones. |
| `stdpath("data")/site/` | Treesitter parsers (`install_dir` in `editor/treesitter.lua`). |
| `stdpath("data")/mason/` | Mason-installed servers, including the JDTLS and Lombok jars. |
| `stdpath("state")/manual-fold-views/` | `mkview` fold state for non-Markdown files. |
| `stdpath("cache")/jdtls_workspace/<sha>/` | Per-project JDTLS workspace. |
| `<dir>/.<name>.md.folds.json` | Markdown fold sidecar, written next to the document itself. |

## Related

- [Architecture](../explanation/architecture.md) — load order and why the directories split this way
- [How to add a plugin](../how-to/add-a-plugin.md)
- [Plugins](plugins.md)
