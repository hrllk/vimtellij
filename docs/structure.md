# Configuration structure

Where each kind of change belongs, and why the directories split this way.

## Load order

`init.lua` sets this. Nothing else does.

1. Bootstrap `lazy.nvim`
2. `config.options` — editor options
3. `config.theme` — highlight overrides that must survive `ColorScheme`
4. `config.keymaps` — global mappings
5. `config.autocmds` — autosave and friends
6. `lazy.setup` — imports `plugins`, `plugins.ai`, `plugins.editor`,
   `plugins.git`, `plugins.lsp`, `plugins.ui`

Feature directories are imported one line each. A new feature directory needs a
new line in `init.lua`; `lua/plugins/` is not scanned recursively.

`ftplugin/` is absent from that list on purpose. Neovim loads it on filetype
detection, which is why `init.lua` carries a commented-out `require("ftplugin")`.

## Directories

| Path | What lives here |
| --- | --- |
| `init.lua` | Load order and the lazy bootstrap. No settings. |
| `lua/plugins/<feature>/` | Plugin specs. Which plugin, and when it loads. |
| `lua/config/` | Editor options, keymaps, autocmds — and modules lifted out of a spec. |
| `ftplugin/` | Per-filetype behavior. Applies only when that filetype opens. |
| `tests/` | Headless specs, run by `scripts/check`. |
| `scripts/check` | Syntax check, full config load, then the specs. |

## Where to put a change

- **New plugin** → one spec at `lua/plugins/<feature>/<name>.lua`.
  Features are `ai`, `editor`, `git`, `lsp`, `ui`.
- **Editor option, no plugin involved** → `lua/config/options.lua`
- **Mapping, no plugin involved** → `lua/config/keymaps.lua`
- **Only for one filetype** → `ftplugin/<filetype>.lua`
- **A color more than one spec reads** → `lua/config/colors.lua`

### When plugin config moves to `lua/config/`

A spec should be readable in one screen — you should see the load trigger
without scrolling. When config crowds that out, move it to `lua/config/` and
require it back from the spec. The module is then testable on its own:
`folding_anchor.lua` is pure text manipulation, so `tests/folding_anchor_spec.lua`
runs it under `nvim --headless -u NONE` with no config loaded at all.

| Module | Required by |
| --- | --- |
| `folding_anchor.lua` | `folding_sidecar.lua` |
| `folding_sidecar.lua` | `plugins/editor/folding.lua` |
| `folding_adapter.lua` | `plugins/editor/folding.lua` |
| `markdown_task_scope.lua` | `plugins/editor/markdown.lua` |
| `snacks_dashboard.lua` | `plugins/snacks.lua` |
| `snacks/` | `plugins/snacks.lua` |

`lua/config/snacks/` is a directory because Snacks takes one large options
table: each file returns a slice, `snacks/init.lua` deep-merges them, and an
explorer change stays out of the picker's diff. Use a directory when you are
splitting one options table; use a single file otherwise.

Naming has no rule and shows it — `snacks_dashboard.lua` (the dashboard
rewrite) and `snacks/dashboard.lua` (a slice of the options table) are
unrelated files one underscore apart. Do not add a third.

### Known exceptions

`dbui.lua`, `integration.lua`, and `snacks.lua` sit at the top of
`lua/plugins/` instead of a feature directory. They predate the split and have
not been sorted. Do not add a fourth.

## What goes in this file

A "why" that fits inside one file goes in that file's header comment —
`lua/config/markdown_task_scope.lua` is the pattern, recording why
`render-markdown`'s own `scope_highlight` was not enough.

`docs/` takes only a "why" that spans several files. Today that is this
document and nothing else.

There is deliberately no list of keymaps, plugins, or options here. `<leader>?`
shows the real mappings and `:Lazy` shows the real plugins. A list here would be
a second copy that goes stale on the next commit — which is what the previous
`docs/` became.
