# How to add a plugin

Add a plugin to this configuration so it installs, loads at the right time, and
does not slow down startup.

## Prerequisites

- The plugin's GitHub path, as `owner/repo`
- Neovim running with this configuration
- Knowing which feature area it belongs to (see step 1)

## Steps

### 1. Pick the directory

One file per plugin, in the directory that matches what it does.

| Directory | For |
| --- | --- |
| `lua/plugins/ai/` | AI completion and assistants |
| `lua/plugins/editor/` | Editing behavior: text objects, formatting, folding, snippets |
| `lua/plugins/git/` | Anything Git |
| `lua/plugins/lsp/` | Language servers, completion, Mason |
| `lua/plugins/ui/` | Appearance: statusline, tabline, notifications, colors |
| `lua/plugins/` (root) | Standalone tools that fit none of the above (`dbui.lua`, `integration.lua`) |

Name the file after the plugin, not the repo owner: `harpoon.lua`, not
`ThePrimeagen-harpoon.lua`.

### 2. Write the spec

Create the file. It must `return` a list of specs, even for one plugin.

```lua
------------------------------
-- short title
-- one line on what it does for you
------------------------------
return {
  {
    "owner/repo",
    event = "VeryLazy",
    opts = {},
  },
}
```

The two-line comment header is the convention across every existing spec. Keep
it; it is what makes `lua/plugins/` skimmable.

### 3. Pick a load trigger

Do not leave this out. A spec with no trigger loads on `VimEnter`, which is
startup cost for something you may never use in a session.

| Trigger | Use when |
| --- | --- |
| `event = "VeryLazy"` | Good default. Loads after the UI is up and the first file is on screen. |
| `event = "InsertEnter"` | Completion, snippets, autopairs. |
| `event = "BufReadPre"` | Anything that must attach to a buffer as it opens (Git signs, inline highlights). |
| `ft = "markdown"` | Filetype-specific. Takes a string or a list. |
| `cmd = "MyCommand"` | Loads on first use of that command. |
| `keys = { ... }` | Loads on first press. Best for anything with a dedicated key. |
| `lazy = false` | Only if it must paint the first frame. Colorscheme, dashboard. |

Prefer `keys` over `event` when the plugin has an entry-point mapping. It gives
you the mapping and the lazy trigger in one declaration:

```lua
keys = {
  { "<leader>x", "<Cmd>MyCommand<CR>", desc = "Do the thing" },
},
```

Check [Keymaps](../reference/keymaps.md) before choosing a key. Nothing in this
configuration detects a conflict; two specs can bind the same key and you find
out by pressing it.

### 4. Configure it

Three ways, in order of preference.

**`opts` table** for anything static. `lazy.nvim` calls `require("plugin").setup(opts)` for you.

```lua
opts = {
  signs = true,
  timeout = 5000,
},
```

**`opts` function** when a value has to be computed or merged into what came before.

```lua
opts = function(_, opts)
  opts.routes = opts.routes or {}
  table.insert(opts.routes, { filter = { event = "notify" } })
end,
```

**`config` function** when setup needs more than `setup()`: keymaps, autocmds, or work after the plugin loads.

```lua
config = function(_, opts)
  require("plugin").setup(opts)
  vim.keymap.set("n", "<leader>x", require("plugin").action, { desc = "..." })
end,
```

Writing `config` means you own the `setup()` call. Forgetting it is the most
common mistake: the plugin installs, the keymaps work, and nothing happens.

Settings that must apply during startup even though the plugin loads later go in
`init`, not `config`. `init` runs for every spec during `lazy.setup()`. See
[Architecture](../explanation/architecture.md#init-versus-config).

Use the palette instead of literal hex values:

```lua
local colors = require("config.colors")
-- ...
  opts = { border = colors.border },
```

### 5. Install

Restart Neovim, or:

```vim
:Lazy sync
```

`lazy.nvim` clones the plugin and writes its commit into `lazy-lock.json`.

### 6. Verify

```sh
scripts/check
```

Expected output:

```
Checking Lua syntax...
Loading Neovim configuration...
Running headless fold tests...
...
All checks passed
```

`All checks passed` on the last line is the pass signal. The test stage prints
its own progress in between, including a few expected `invalid sidecar format`
notices. See [How to run checks](run-checks.md).

Then confirm the plugin is registered and lazy-loading as intended:

```vim
:Lazy
```

Find it in the list. The `Loaded` and `Not Loaded` sections tell you whether the
trigger did what you expected. Press `<CR>` on the entry to see its resolved
spec.

## Adding a new feature directory

A new subdirectory under `lua/plugins/` needs a line in `init.lua`. `lazy.nvim`
does not recurse.

```lua
require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.ai" },
  { import = "plugins.editor" },
  { import = "plugins.git" },
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.mynew" },   -- add this
}, opts)
```

Skip it and the specs are silently ignored: no error, no warning, the plugins
just never install.

## Troubleshooting

**The plugin does not appear in `:Lazy` at all.**
Its directory has no `{ import = ... }` line in `init.lua`. See above. If the
file is directly in `lua/plugins/`, check that it `return`s a table and that the
outer table is a list: `return { { "owner/repo" } }`, not `return { "owner/repo" }`
unless it is a bare single-string spec.

**It is listed but never loads.**
The trigger never fires. Run `:Lazy profile` to see load times and reasons. A
`ft` trigger with the wrong filetype name is the usual cause; check with
`:set filetype?` in a target buffer.

**It loads but nothing is configured.**
You wrote `config = function() ... end` and did not call `setup()` inside it.
Writing `config` replaces `lazy.nvim`'s default behavior.

**`scripts/check` fails after adding it.**
Read the error. The check loads the full configuration headlessly, so a
module-level `require` of something that only exists after the plugin loads will
fail here even if it works interactively. Move that `require` inside `config`.

**A keymap does nothing, or does the wrong thing.**
Something else has the key. Check with:

```vim
:verbose nmap <leader>x
```

The output names the file and line that bound it last.

## Removing a plugin

Delete the file and run `:Lazy sync`. Because keymaps and autocmds live in the
spec, deleting the file removes them too. Two things do not clean themselves up:

- Mappings you put in `lua/config/keymaps.lua` instead of the spec
- References from other specs' `dependencies`

Grep for the plugin name before you finish:

```sh
rg "plugin-name" lua/ ftplugin/
```

## Related

- [Plugins](../reference/plugins.md) — every current spec and its trigger
- [Architecture](../explanation/architecture.md) — why specs are organized this way
- [How to run checks](run-checks.md)
