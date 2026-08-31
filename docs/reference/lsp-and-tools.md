# LSP and tools

Language servers, parsers, formatters, linters, and filetype settings: what is
configured, where, and what each one needs installed.

## Language servers

Four servers are configured in `lua/plugins/lsp/lspconfig.lua`. All of them get
`nvim-cmp`'s capabilities via `require("cmp_nvim_lsp").default_capabilities()`.

| Server | Language | Enabled | Settings |
| --- | --- | --- | --- |
| `lua_ls` | Lua | Always | Capabilities only. `.luarc.json` declares `vim` as a global. |
| `gopls` | Go | Always | See below. |
| `marksman` | Markdown | Always | Capabilities only. |
| `ts_ls` | TypeScript, JavaScript | Only if `typescript-language-server` is on `PATH` | Capabilities only. |
| `jdtls` | Java | Started per-buffer by `ftplugin/java.lua`, not by `lspconfig` | See [Java](#java). |

`ts_ls` is behind a `vim.fn.executable()` probe (`lspconfig.lua:43`). That is why
the spec declares `mason.nvim` as a dependency: Mason prepends its `bin`
directory to `PATH` during setup, and without the declared dependency the load
order is undefined, so the probe could run first and silently skip the server.

### gopls settings

Source: `lua/plugins/lsp/lspconfig.lua:22-37`.

| Setting | Value | Effect |
| --- | --- | --- |
| `staticcheck` | `true` | Run the staticcheck analyzer set. |
| `completeUnimported` | `true` | Offer symbols from packages not yet imported, and add the import on accept. |
| `usePlaceholders` | `true` | Fill function call arguments as snippet placeholders. |
| `analyses.unusedparams` | `true` | Flag unused function parameters. |
| `analyses.nilness` | `true` | Flag redundant nil checks and nil dereferences. |
| `analyses.shadow` | `true` | Flag shadowed variables. |

## Mason

`mason.nvim` installs servers and tools into `stdpath("data")/mason/`.

Two registries, in order (`lua/plugins/lsp/mason.lua`):

1. `github:nvim-java/mason-registry`
2. `github:mason-org/mason-registry`

The `nvim-java` registry comes first because it supplies the JDTLS and
`lombok-nightly` packages that `ftplugin/java.lua` expects at specific paths.

### Auto-installed

`mason-lspconfig.nvim` ensures these are present (`lua/plugins/lsp/mason-lspconfig.lua`):

- `gopls`
- `lua_ls`
- `marksman`
- `ts_ls`

`jdtls` is deliberately not in that list. Java starts through
`ftplugin/java.lua`, which resolves the Mason package path itself. Install it
manually with `:MasonInstall jdtls lombok-nightly`.

## Java

`ftplugin/java.lua` runs once per Java buffer and calls
`require("jdtls").start_or_attach(config)`. It does more setup than the other
languages because JDTLS is an Eclipse application, not a single binary.

### What it resolves at runtime

| Step | How | Fallback |
| --- | --- | --- |
| Project root | `vim.fs.root` against 8 markers: `.git`, `mvnw`, `gradlew`, `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle`, `settings.gradle.kts` | Returns early, JDTLS does not start |
| Equinox launcher jar | Globs `<mason>/plugins/org.eclipse.equinox.launcher_*.jar` | `<mason>/plugins/org.eclipse.equinox.launcher.jar` |
| Config directory | First of `config_mac_arm`, `config_mac` that exists | `config_mac` |
| Lombok agent | `<mason>/packages/lombok-nightly/lombok.jar` | Warns and starts without it |
| Workspace | `stdpath("cache")/jdtls_workspace/<first 16 chars of sha256(root)>` | n/a |

Hashing the root path means two projects with the same directory name get
separate workspaces, and re-opening a project reuses its index instead of
rebuilding it.

### JVM flags

Source: `ftplugin/java.lua:67-74`.

| Flag | Purpose |
| --- | --- |
| `-Xms512m` / `-Xmx4g` | Initial and maximum heap. 4 GB suits large multi-module projects. |
| `-XX:+UseG1GC` | G1 collector. |
| `-XX:MaxGCPauseMillis=200` | Target pause. Keeps completion from stalling during a collection. |
| `-XX:+UseStringDeduplication` | Cuts heap on the large string sets JDTLS holds. |
| `-Dlog.level=ERROR` | Suppress JDTLS chatter. |
| `--add-modules=ALL-SYSTEM` | Required on JDK 9+. |
| `--add-opens java.base/java.util`, `java.base/java.lang` | Required by JDTLS reflection on JDK 16+. |

### Completion filtering

`filteredTypes` drops these from Java completion candidates:
`com.sun.*`, `io.micrometer.shaded.*`, `java.awt.*`, `jdk.*`, `sun.*`.
`guessMethodArguments` is off, so method calls complete without argument
placeholders.

`debounce_text_changes` is 200 ms, higher than the LSP default, to reduce
re-analysis on a large classpath.

## Treesitter

`lua/plugins/editor/treesitter.lua` installs parsers into
`stdpath("data")/site` and starts highlighting via a `FileType` autocmd on the
same language list.

20 parsers: `vim`, `vimdoc`, `lua`, `java`, `kotlin`, `go`, `gomod`,
`javascript`, `typescript`, `html`, `css`, `json`, `tsx`, `markdown`,
`markdown_inline`, `gitignore`, `sql`, `http`, `nginx`, `xml`.

`rest.nvim` appends `http` to `ensure_installed` from its own spec
(`lua/plugins/integration.lua`), so `http` would be installed even if it were
dropped from the list above.

`build = ":TSUpdate"` recompiles parsers whenever `lazy.nvim` updates the
plugin. The highlight autocmd wraps `vim.treesitter.start` in a `pcall`, so a
parser that failed to compile degrades to no highlighting instead of an error on
every buffer open.

Which plugins depend on Treesitter: `nvim-ts-autotag`, `render-markdown.nvim`,
`nvim-autopairs` (via `check_ts`), `file-line-range-history`, `rest.nvim`.

## Formatting and diagnostics

`none-ls.nvim` (`lua/plugins/editor/formatting.lua`) registers external tools as
if they were an LSP server.

| Source | Kind | Applies to | Needs installed |
| --- | --- | --- | --- |
| `stylua` | Formatter | Lua | `stylua` on `PATH` or via Mason |
| `prettier` | Formatter | JS, TS, JSON, CSS, HTML, Markdown, YAML | `prettier` on `PATH` or via Mason |
| `eslint_d` | Diagnostics | JS, TS | `eslint_d` on `PATH` or via Mason |

None of the three is auto-installed. `mason-lspconfig` only handles language
servers; use `:Mason` to add these.

Stylua reads `stylua.toml` at the config root: 2-space indent, 120-column width.
That is why the Lua files here are 2-space while `shiftwidth` is globally 4.

Both `<leader>cf` and `<leader>lf` call `vim.lsp.buf.format`, which fans out to
every attached client including `none-ls`. See [Keymaps](keymaps.md#lsp).

## Filetype overrides

Neovim sources `ftplugin/<filetype>.lua` automatically when a buffer's
`filetype` matches. No registration is needed.

| Filetype | File | Effect |
| --- | --- | --- |
| `lua` | `ftplugin/lua.lua` | `tabstop`, `softtabstop`, `shiftwidth` = 2 |
| `javascript` | `ftplugin/javascript.lua` | Same, 2 |
| `typescriptreact` | `ftplugin/typescriptreact.lua` | Same, 2 |
| `json` | `ftplugin/json.lua` | `formatprg = "jq ."`, so `gq` reformats through jq |
| `java` | `ftplugin/java.lua` | Starts JDTLS, as above |

The indent files use `vim.opt_local` and `json.lua` uses `vim.bo`. Both are
buffer-scoped, so none of them touch the global values in
[Options](options.md#indentation).

Note that `typescript` (plain `.ts`) has no ftplugin. Only `.tsx` files get the
2-space override; a `.ts` file keeps the global 4.

## External tools this configuration expects

| Tool | Needed for | What happens without it |
| --- | --- | --- |
| Neovim 0.11+ | `vim.lsp.config` / `vim.lsp.enable` API | Config fails to load |
| Git | `lazy.nvim` cloning, Gitsigns, Lazygit | No plugins install |
| A Nerd Font | Icons in explorer, incline, lualine, checkboxes | Boxes instead of glyphs |
| `ripgrep` | Snacks picker search, `scripts/check` | `scripts/check` fails; picker search degrades |
| Node.js and npm | `typescript-language-server`, `prettier`, `eslint_d` | `ts_ls` is skipped by the `executable()` probe |
| Java (JDK 17+) | JDTLS | Java buffers open without an LSP |
| `jq` | JSON `gq` formatting | `gq` does nothing useful in JSON |
| `curl` or `wget` | Mermaid download for Markdown preview | Preview uses the plugin's bundled Mermaid |
| Yarn | `markdown-preview.nvim` build step | Preview does not start |
| `lazygit` | `<leader>gg` | Key errors |

Snacks handles one `ripgrep` edge case itself: a GUI-launched Neovim may not
inherit the shell's `PATH`, and Snacks spawns `rg` directly through libuv rather
than a shell. When `rg` is not found, `lua/plugins/snacks.lua:19-27` globs for a
Codex-bundled copy under `/opt/homebrew/Caskroom/codex/*/codex-path/rg` and
prepends its directory to `vim.env.PATH`.

## Related

- [Plugins](plugins.md)
- [Directory layout](directory-layout.md)
- [How to run checks](../how-to/run-checks.md)
