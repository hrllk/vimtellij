# How to change keymaps and options

Change a mapping or an editor setting, and know it took effect without breaking
something else.

## Prerequisites

- Neovim running with this configuration
- `scripts/check` runnable (needs `ripgrep`)

## Decide where the change goes

This is the whole problem. Put it in the wrong file and it either does not
apply, or it applies and something overwrites it later.

| What you are changing | Put it in |
| --- | --- |
| An editor-wide option | `lua/config/options.lua` |
| A mapping not tied to a plugin | `lua/config/keymaps.lua` |
| A mapping that triggers a plugin | That plugin's spec, in its `keys` field |
| A setting for one filetype | `ftplugin/<filetype>.lua` |
| A shared color | `lua/config/colors.lua` |
| A plugin's own options | That plugin's spec, in `opts` |

The rule: **the change lives with whatever owns the thing it affects.** A
Harpoon mapping belongs in `harpoon.lua`, so deleting Harpoon deletes the
mapping.

## Change an option

### 1. Find it

Every global option is in `lua/config/options.lua`, grouped by concern. Eight
fold options are the exception; they are in
`lua/plugins/editor/folding.lua`'s `init`. See
[Options](../reference/options.md#options-set-elsewhere).

### 2. Edit it

Keep the trailing comment. Every line in that file has one.

```lua
vim.opt.scrolloff = 5 -- number of lines to keep above/below cursor
```

### 3. Verify

Restart Neovim, then check the live value:

```vim
:set scrolloff?
```

Expected: `scrolloff=5`.

If it shows the old value, something else set it after `options.lua` ran. Find
out what:

```vim
:verbose set scrolloff?
```

The output names the last file to set it.

## Change an option for one filetype only

Create or edit `ftplugin/<filetype>.lua`. Neovim sources it automatically when
the filetype matches; there is nothing to register.

```lua
-- ftplugin/python.lua
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
```

Use `vim.opt_local`, not `vim.opt`. `vim.opt` sets the global value, and one
Python buffer would change indentation everywhere.

Verify by opening a matching file and running `:set shiftwidth?`. Open a file of
a different type and confirm it still shows the global value.

Note that `typescript` currently has no ftplugin here. Only `.tsx` gets the
2-space override.

## Add or change a global mapping

### 1. Check the key is free

```vim
:verbose nmap <leader>x
```

`No mapping found` means it is free. Otherwise the output names the file and
line that owns it. Also scan [Keymaps](../reference/keymaps.md), which lists
every mapping in the configuration with its source.

Nothing in this configuration detects a conflict at load time. Two files can
bind the same key and the last one to run wins. Buffer-local mappings always
beat global ones in the buffers where they apply, which is why `<leader>gd`
resolves to Gitsigns rather than the Snacks picker.

### 2. Add it

In `lua/config/keymaps.lua`, under the matching section header:

```lua
keymap.set("n", "<leader>x", ":MyCommand<CR>", opts)
```

`keymap` is `vim.keymap` (line 13) and `opts` is
`{ noremap = true, silent = true }` (line 14). Both are file-local shorthands.

For anything with logic, use a function and give it a `desc`. `desc` is what
which-key shows in the popup.

```lua
keymap.set("n", "<leader>x", function()
  -- ...
end, { desc = "What this does" })
```

### 3. Verify

Restart Neovim and press the key. Then confirm it resolves to your definition:

```vim
:verbose nmap <leader>x
```

The output should name `lua/config/keymaps.lua`.

## Add a mapping that belongs to a plugin

Put it in the plugin's `keys` field, not in `keymaps.lua`. That way it also
serves as the lazy-load trigger, and deleting the plugin deletes the mapping.

```lua
return {
  {
    "owner/repo",
    keys = {
      { "<leader>x", "<Cmd>PluginCommand<CR>", desc = "Do the thing" },
    },
  },
}
```

For a mapping that should exist only in buffers the plugin attached to, set it
in `config` with a `buffer` option, the way Gitsigns does in its `on_attach`:

```lua
vim.keymap.set("n", "<leader>x", action, { buffer = bufnr, desc = "..." })
```

## Change a color

Edit `lua/config/colors.lua`. Six files read that table, so one hex value
changes separators, borders, the dashboard, notifications, and Markdown code
blocks together.

```lua
return {
  accent = "#2DD4BF",   -- change this
  ...
}
```

Restart Neovim. To check a specific group took the new value:

```vim
:highlight WinSeparator
```

If a group did not change, it is probably set by a plugin after the colorscheme.
See [Theme and colors](../reference/theme-and-colors.md#highlight-overrides) for
the three layers and what each one owns.

## Verify the whole configuration still loads

After any change:

```sh
scripts/check
```

Expected:

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

This catches syntax errors and load-time failures that you would otherwise only
see on the next fresh start.

## Troubleshooting

**The option reverts.**
Something set it later. `:verbose set <option>?` names the culprit. Common case:
an ftplugin overriding a global you just changed, which is working as intended.

**The mapping does nothing.**
Either the key never reaches Neovim (terminal or tmux is eating it, common with
`<C-`, `<M-`, and `<S-` combinations) or something else bound it.
`:verbose nmap <key>` distinguishes the two: no output at all means the binding
is missing, output naming another file means a conflict.

**The mapping works but the wrong thing happens.**
A buffer-local mapping is shadowing your global one. Run `:verbose nmap <key>`
inside the buffer where it misbehaves, not from a scratch buffer.

**`<Tab>` or `<C-i>` behaves oddly.**
They are the same byte in a terminal, and `<Tab>` is taken by tab navigation
(`keymaps.lua:79`). That is why `g[` and `g]` exist for jumplist navigation.

**which-key does not show a description.**
You passed `opts` (which has no `desc`) instead of a table with `desc`. Pass
`{ desc = "..." }`, or merge: `vim.tbl_extend("force", opts, { desc = "..." })`.

**`scripts/check` fails with a syntax error and no line number.**
The first stage runs `loadfile` per file and prints the failing path. Read the
first error, not the last; later failures are usually consequences.

## Related

- [Keymaps](../reference/keymaps.md) — every current mapping
- [Options](../reference/options.md) — every current option
- [Theme and colors](../reference/theme-and-colors.md)
- [How to run checks](run-checks.md)
