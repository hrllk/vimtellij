# Architecture

Why this configuration is split the way it is, and what happens in what order
when you start Neovim.

## The problem a Neovim config has

A Neovim configuration is one giant mutable global. Every plugin can set any
option, bind any key, and overwrite any highlight group, at any point during
startup. Nothing enforces an order and nothing reports a conflict. Two plugins
that both set `Normal` produce whichever result ran last, and you find out by
looking at the screen.

Configs that grow without structure hit three failure modes:

1. **Nobody knows what sets what.** A color is wrong, and the answer is in one of forty files.
2. **Load order is accidental.** Something works because a plugin happened to load second, and breaks when you add an unrelated plugin.
3. **Everything loads at startup.** Neovim takes two seconds to open a file.

This configuration answers each one with a structural rule.

## Rule 1: who owns what is decided by directory

```
lua/config/     editor-wide settings + feature libraries
lua/plugins/    lazy.nvim specs, one file per plugin
ftplugin/       per-filetype settings
```

The split is not by topic. It is by **who loads it**.

`lua/config/` is loaded by `init.lua`, explicitly, in a known order. Nothing in
it is optional and nothing in it is lazy.

`lua/plugins/` is loaded by `lazy.nvim`, on triggers each spec declares itself.
`init.lua` never names an individual plugin file.

`ftplugin/` is loaded by Neovim's own runtime, when a buffer's `filetype` is
set. It is not registered anywhere; the filename is the registration.

Once you know which of the three a setting lives in, you know when it runs. That
is the whole point of the split.

## Rule 2: plugin configuration lives next to the plugin spec

A plugin's keymaps, options, highlights, and autocmds all go in the same file as
its `lazy.nvim` spec.

The alternative, which many configs use, is a central `keymaps.lua` holding
every mapping and a central `autocmds.lua` holding every autocmd. It reads well
until you delete a plugin: now you have three orphaned mappings and an autocmd
referencing a module that no longer exists, and nothing tells you.

Here, deleting `lua/plugins/editor/harpoon.lua` deletes Harpoon and both of its
keymaps in one operation. There is nothing left to clean up.

The cost is that "where is `<leader>a` bound?" is not answerable by opening one
file. That cost is paid by [Keymaps](../reference/keymaps.md), which lists every
mapping with its source line.

`lua/config/keymaps.lua` still exists, and holds only mappings that do not belong
to a plugin: window management, editing, and the LSP mappings that work against
Neovim's builtin client rather than a specific plugin.

## Rule 3: shared values go in a table with no logic

`lua/config/colors.lua` returns seven key-value pairs and nothing else. No
`require`, no function calls, no conditionals.

That matters because six different files read it, at six different points in
startup: during `lazy.nvim` spec evaluation, inside a plugin's `init`, inside a
plugin's `config`, and from a `ColorScheme` autocmd. A module with side effects
would behave differently depending on which one got there first. A plain table
cannot.

The result is that changing one hex value in `colors.lua` recolors separators,
borders, the dashboard, notifications, and Markdown code blocks together. See
[Theme and colors](../reference/theme-and-colors.md).

## Startup sequence

```
nvim
 │
 ├─ init.lua
 │   │
 │   ├─ 1. bootstrap lazy.nvim
 │   │      clone into stdpath("data")/lazy/lazy.nvim if missing
 │   │      prepend it to runtimepath
 │   │
 │   ├─ 2. require("config.options")    all vim.opt settings
 │   ├─ 3. require("config.theme")      Visual highlight override
 │   ├─ 4. require("config.keymaps")    mapleader + global mappings
 │   ├─ 5. require("config.autocmds")   autosave
 │   │
 │   └─ 6. require("lazy").setup({ 6 imports }, opts)
 │            │
 │            ├─ evaluate every spec file  (module-level code runs here,
 │            │                             e.g. require("config.colors"))
 │            ├─ run init() on every spec  (even lazy ones)
 │            └─ load lazy = false specs, by priority descending
 │                  tokyonight (1000), snacks (1000), incline (1200),
 │                  treesitter, noice, which-key, showkeys
 │
 ├─ VimEnter        specs with no trigger load
 ├─ UIEnter         lualine
 ├─ VeryLazy        ufo, harpoon, todo-comments, colorful-winsep,
 │                  mason-lspconfig
 ├─ BufReadPre      gitsigns, mini.hipatterns, incline, autotag
 ├─ InsertEnter     nvim-cmp, LuaSnip, autopairs, supermaven
 └─ on demand       ft=, cmd=, keys= specs
```

Steps 2 through 5 come before `lazy.setup()` for one reason: `mapleader` must be
set before any spec declares a `<leader>` keymap, or `lazy.nvim` records the
literal `<leader>` string against the wrong key. Everything else in that block
could move, but keeping all four together makes the invariant obvious.

### `init` versus `config`

Both are `lazy.nvim` spec fields, and the difference decides whether a setting
survives lazy loading.

`init` runs during `lazy.setup()`, before the plugin is loaded, for every spec
including lazy ones. `config` runs when the plugin actually loads.

Anything that must apply during startup, even though the plugin itself loads
later, goes in `init`. Three specs here rely on that:

| Spec | In `init` | Why |
| --- | --- | --- |
| `editor/folding.lua` | 8 fold options | Buffers open before `VeryLazy` fires. Without them, the first file opens with folds in the wrong state. |
| `snacks.lua` | `rg` PATH patch, picker highlights | Snacks spawns `rg` through libuv, not a shell, so `PATH` must be right before the first picker call. |
| `dbui.lua` | `db_ui_winwidth`, buffer keymaps | `vim-dadbod-ui` reads its globals at load, and the keymap autocmds must exist before the first DBUI buffer. |

## Explicit imports, not a wildcard

`init.lua` lists all six spec sources by hand:

```lua
require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.ai" },
  { import = "plugins.editor" },
  { import = "plugins.git" },
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
}, opts)
```

`{ import = "plugins" }` picks up only the files directly in `lua/plugins/`. It
does not recurse. So each subdirectory needs its own line.

The trade-off is real. A wildcard would mean a new directory just works. But
`lazy.nvim` gives no warning for a directory it was never told about: the specs
are simply absent, the plugins never install, and the failure looks like "my
plugin does nothing" rather than "you forgot a line."

The explicit list makes the set of feature areas visible in one place, at the
cost of one line when you add a seventh. That is the deal this config takes. If
you add a directory and its plugins do not appear, this is why. See
[How to add a plugin](../how-to/add-a-plugin.md).

## Feature modules under `lua/config/`

Five files in `lua/config/` are not settings. They are libraries that a plugin
spec requires:

| Module | Required by |
| --- | --- |
| `folding_anchor.lua` | `folding_sidecar.lua` |
| `folding_sidecar.lua` | `plugins/editor/folding.lua` |
| `folding_adapter.lua` | `plugins/editor/folding.lua` |
| `markdown_task_scope.lua` | `plugins/editor/markdown.lua` |
| `snacks_dashboard.lua` | `plugins/snacks.lua` |

They live outside `lua/plugins/` because a plugin spec file should be readable
in one screen. `lua/plugins/editor/folding.lua` is already 227 lines; inlining
the 300 lines of sidecar logic would bury the spec.

The split also makes them testable. `folding_anchor.lua` is pure text
manipulation with no Neovim API calls, so `tests/folding_anchor_spec.lua` runs
it under `nvim --headless -u NONE` with no config loaded at all. See
[Fold persistence](fold-persistence.md).

`lua/config/snacks/` follows the same idea one level down: each file returns a
plain options table, and `init.lua` deep-merges them. Snacks takes one large
options table, and splitting it by concern keeps explorer changes out of the
picker's diff.

## What this structure gives up

**Startup time is not optimized past the obvious.** Seven plugins load
eagerly. `showkeys` with `lazy = false` and `auto_start = true` is a deliberate
choice, not an oversight, but it is startup cost for a display feature.

**Keymap conflicts are not detected.** Nothing checks whether two files bind the
same key. `<leader>gd` is bound in both `plugins/snacks.lua` and
`plugins/git/gitsigns.lua`, and the collision is invisible until you press it.
See [Keymaps](../reference/keymaps.md#leadergd-is-bound-twice).

**Dead references are not detected either.** `lua/config/keymaps.lua:99-100`
call into `springboot-nvim`, which no spec declares. The mapping exists, and
errors on press.

Both are the price of "configuration next to the spec." A central keymap
registry would catch them; it would also reintroduce the orphaning problem that
rule 2 exists to avoid. The current answer is `scripts/check` for load errors
and [Keymaps](../reference/keymaps.md) for conflicts, both of which are manual.

## Related

- [Directory layout](../reference/directory-layout.md) — what every file is
- [Fold persistence](fold-persistence.md) — the one subsystem with real design behind it
- [How to add a plugin](../how-to/add-a-plugin.md)
