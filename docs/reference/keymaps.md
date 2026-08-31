# Keymaps

Every mapping this configuration defines, grouped by what it does, with the file
and line that defines it.

The leader key is `Space` (`lua/config/keymaps.lua:10`).

Mappings come from three places, and that matters when two of them collide:

1. **`lua/config/keymaps.lua`** — global, set at startup.
2. **Plugin `keys =` specs** — global, and they lazy-load the plugin on first press.
3. **Buffer-local mappings** — set in an `on_attach` or a `FileType` autocmd. These win over a global mapping in the buffers where they apply.

Mode column: `n` normal, `i` insert, `v` visual, `x` visual (charwise/linewise, not select), `o` operator-pending.

## Windows and tabs

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `ss` | n | Horizontal split | `config/keymaps.lua:54` |
| `sv` | n | Vertical split | `config/keymaps.lua:55` |
| `sk` | n | Grow window height by 5 | `config/keymaps.lua:71` |
| `sj` | n | Shrink window height by 5 (floor 1) | `config/keymaps.lua:72` |
| `sl` | n | Grow window width by 5 | `config/keymaps.lua:73` |
| `sh` | n | Shrink window width by 5 (floor 1) | `config/keymaps.lua:74` |
| `te` | n | Open a new tab | `config/keymaps.lua:77` |
| `to` | n | Close all other tabs | `config/keymaps.lua:78` |
| `<Tab>` | n | Next tab | `config/keymaps.lua:79` |
| `<S-Tab>` | n | Previous tab | `config/keymaps.lua:80` |

The four resize mappings call a shared `resize_current_window` helper
(`config/keymaps.lua:57-69`) rather than `:resize`, so they act on the window ID
and clamp to a minimum of 1.

## Movement and viewport

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `<M-j>` | n | Scroll viewport down one line, cursor stays | `config/keymaps.lua:25` |
| `<M-k>` | n | Scroll viewport up one line, cursor stays | `config/keymaps.lua:26` |
| `g[` | n | Jumplist backward (feeds `<C-o>`) | `config/keymaps.lua:29` |
| `g]` | n | Jumplist forward (feeds `<C-i>`) | `config/keymaps.lua:35` |

`g[` and `g]` exist because `<C-i>` and `<Tab>` are the same byte in a terminal,
and `<Tab>` is taken by tab navigation above. They feed the original keys through
`nvim_feedkeys` with `noremap`, so the builtin jumplist behavior is preserved.

## Editing

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `+` | n | Increment the number under the cursor | `config/keymaps.lua:21` |
| `-` | n | Decrement the number under the cursor | `config/keymaps.lua:22` |
| `<Esc>` | n | Clear search highlight (`:noh`) | `config/keymaps.lua:41` |
| `x` | n | Delete the character under the cursor without yanking it | `config/keymaps.lua:44` |
| `p` | x | Paste over a selection without clobbering the register | `config/keymaps.lua:47` |
| `<C-a>` | n | Select the whole buffer | `config/keymaps.lua:87` |
| `>` | v | Indent and keep the selection | `config/keymaps.lua:88` |
| `<` | v | Outdent and keep the selection | `config/keymaps.lua:89` |
| `;ccs` | v | snake_case to camelCase, with confirmation | `config/keymaps.lua:85` |
| `;csc` | v | camelCase to snake_case, with confirmation | `config/keymaps.lua:86` |

Both case-conversion mappings use `:s` with the `c` flag, so Vim asks before
each replacement.

`+` and `-` map to `<C-a>` and `<C-x>`, and `<C-a>` is separately remapped to
select-all. These do not conflict: `vim.keymap.set` defaults to `remap = false`,
so `+` reaches the builtin increment, not the select-all mapping.

## LSP

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `gd` | n | Go to definition | `config/keymaps.lua:110` |
| `gD` | n | Go to declaration | `config/keymaps.lua:109` |
| `gI` | n | Go to implementation | `config/keymaps.lua:122` |
| `gr` | n | References, in a Snacks `select` picker, declaration and current included | `config/keymaps.lua:123` |
| `gl` | n | Open the diagnostic float for the current line | `config/keymaps.lua:130` |
| `K` | n | Fold preview if the cursor is on a closed fold, otherwise hover docs | `config/keymaps.lua:111` |
| `<leader>O` | n | Code action | `config/keymaps.lua:108` |
| `<leader>lf` | n | Format the buffer asynchronously via LSP | `config/keymaps.lua:131` |
| `<leader>cf` | n, v | Format the buffer or selection, synchronously | `plugins/editor/formatting.lua:23` |
| `<leader>rn` | n | Incremental rename with live preview | `plugins/editor/rename.lua:11` |
| `<C-A-o>` | n | Organize imports (JDTLS, Java only) | `config/keymaps.lua:103` |

`K` tries `ufo.peekFoldedLinesUnderCursor()` first and falls back to
`vim.lsp.buf.hover()` only when that returns no window. The `pcall` means it
still works if `nvim-ufo` has not loaded.

`<leader>lf` and `<leader>cf` both call `vim.lsp.buf.format`, which fans out to
every attached client, `none-ls` included. Two differences: `<leader>lf` passes
`async = true` and is normal mode only, while `<leader>cf` is synchronous and
also works on a visual selection. Stylua and Prettier apply either way, because
`none-ls` registers itself as an LSP client.

## Completion

Active only while the completion popup is open (`plugins/lsp/completion.lua`).

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `<C-j>` | i | Next completion item | `plugins/lsp/completion.lua:60` |
| `<C-k>` | i | Previous completion item | `plugins/lsp/completion.lua:59` |
| `<C-b>` | i | Scroll the docs window up 4 lines | `plugins/lsp/completion.lua:61` |
| `<C-f>` | i | Scroll the docs window down 4 lines | `plugins/lsp/completion.lua:62` |
| `<C-Space>` | i | Trigger completion | `plugins/lsp/completion.lua:63` |
| `<C-e>` | i | Abort completion | `plugins/lsp/completion.lua:64` |
| `<CR>` | i | Confirm, without auto-selecting the first item | `plugins/lsp/completion.lua:65` |

Completion starts after 2 typed characters, 3 in Java.

## Files and search

All from `lua/plugins/snacks.lua`. Each one lazy-loads Snacks on first press.

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `<leader>e` | n | Toggle the file explorer | `plugins/snacks.lua:50` |
| `<leader>ff` | n | Find files, hidden files included | `plugins/snacks.lua:53` |
| `<leader>fg` | n | Grep the project | `plugins/snacks.lua:54` |
| `<leader>fb` | n | Switch buffers | `plugins/snacks.lua:51` |
| `<leader>fr` | n | Recent files | `plugins/snacks.lua:56` |
| `<leader>fp` | n | Projects | `plugins/snacks.lua:55` |
| `<leader>fc` | n | Find a file inside this Neovim config | `plugins/snacks.lua:52` |

### Inside the explorer

| Key | Action | Defined in |
| --- | --- | --- |
| `D` | Diff the two files selected with `<Tab>`. Warns if the selection is not exactly two files. | `config/snacks/explorer.lua:68` |
| `=` | Cycle the explorer width: default, 30%, 40%, 50%, back to default | `config/snacks/explorer.lua:69` |

The width cycle keeps per-picker state in a weak-keyed table, so closing the
explorer resets it. See `docs/archive/explorer-width-toggle-design.md` for the
design record.

## Git

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `<leader>gg` | n | Lazygit at the repository root | `plugins/snacks.lua:58` |
| `<leader>gb` | n | Branch picker | `plugins/snacks.lua:65` |
| `<leader>gl` | n | Commit log | `plugins/snacks.lua:66` |
| `<leader>gL` | n | Log for the current line | `plugins/snacks.lua:67` |
| `<leader>gs` | n | Status picker | `plugins/snacks.lua:68` |
| `<leader>gS` | n | Stash picker | `plugins/snacks.lua:69` |
| `<leader>gf` | n | Log for the current file | `plugins/snacks.lua:71` |
| `<leader>gflh` | x | Git history for the selected line range | `plugins/git/blame-tracker.lua:13` |

### Gitsigns

Buffer-local, attached on `BufReadPre` in any file inside a Git repository
(`plugins/git/gitsigns.lua`, `on_attach`).

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `]h` | n | Next hunk (next diff change when in diff mode) | `plugins/git/gitsigns.lua:33` |
| `[h` | n | Previous hunk | `plugins/git/gitsigns.lua:40` |
| `]H` | n | Last hunk | `plugins/git/gitsigns.lua:47` |
| `[H` | n | First hunk | `plugins/git/gitsigns.lua:48` |
| `ih` | o, x | Hunk text object | `plugins/git/gitsigns.lua:60` |
| `<leader>ghs` | n, v | Stage hunk | `plugins/git/gitsigns.lua:49` |
| `<leader>ghr` | n, v | Reset hunk | `plugins/git/gitsigns.lua:50` |
| `<leader>ghS` | n | Stage the whole buffer | `plugins/git/gitsigns.lua:51` |
| `<leader>ghu` | n | Undo the last stage | `plugins/git/gitsigns.lua:52` |
| `<leader>ghR` | n | Reset the whole buffer | `plugins/git/gitsigns.lua:53` |
| `<leader>ghp` | n | Preview the hunk inline | `plugins/git/gitsigns.lua:54` |
| `<leader>ghb` | n | Full blame for the current line | `plugins/git/gitsigns.lua:55` |
| `<leader>ghB` | n | Blame the whole buffer | `plugins/git/gitsigns.lua:56` |
| `<leader>ghd` | n | Diff against the index | `plugins/git/gitsigns.lua:57` |
| `<leader>ghD` | n | Diff against the previous commit | `plugins/git/gitsigns.lua:58` |

### `<leader>gd` is bound twice

| Binding | Scope | Action |
| --- | --- | --- |
| `plugins/snacks.lua:70` | Global, via a lazy `keys =` spec | Open the Snacks hunk-diff picker |
| `plugins/git/gitsigns.lua:59` | Buffer-local, set in `on_attach` | `gs.diffthis`, a diff split for the current file |

The buffer-local mapping wins wherever Gitsigns has attached, which is every
tracked file. In practice `<leader>gd` opens a diff split, and the Snacks picker
is only reachable in buffers Gitsigns skipped. Drop one of the two if you want a
predictable key.

## Folding

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `zR` | n | Open all folds | `plugins/editor/folding.lua:104` |
| `zM` | n | Close all folds | `plugins/editor/folding.lua:105` |
| `zf` | x | **Markdown only.** Fold the selection and persist it to the sidecar | `plugins/editor/folding.lua:175` |
| `zo` | n | **Markdown only.** Open the fold under the cursor and drop its sidecar entry | `plugins/editor/folding.lua:187` |

The Markdown pair is buffer-local, installed by a `FileType markdown` autocmd
and guarded by `markdown_fold_mappings_installed` so it never doubles up. In
every other filetype `zf` and `zo` keep their builtin behavior and fold state
goes through `mkview`. See [Fold persistence](../explanation/fold-persistence.md).

There is also no keymap for fold preview on idle: a `CursorHold` autocmd
(`plugins/editor/folding.lua:206`) peeks automatically when the cursor rests on a
closed fold, after `updatetime` (100 ms).

## Tools

| Key | Mode | Action | Defined in |
| --- | --- | --- | --- |
| `<leader>u` | n | Toggle the undo tree | `plugins/editor/undotree.lua:9` |
| `<leader>a` | n | Harpoon: mark the current file | `plugins/editor/harpoon.lua:13` |
| `<C-e>` | n | Harpoon: toggle the quick menu | `plugins/editor/harpoon.lua:16` |
| `<leader>db` | n | Toggle the database UI | `plugins/dbui.lua:104` |
| `<leader>dB` | n | Open the database UI | `plugins/dbui.lua:105` |
| `<leader>?` | n | Show buffer-local keymaps (which-key) | `plugins/ui/which-key.lua:13` |
| `rr` | n | Run the HTTP request under the cursor (rest.nvim) | `config/keymaps.lua:96` |

`<C-e>` in normal mode is Harpoon. The builtin scroll-down is still reachable as
`<M-j>`, which is mapped non-recursively.

### Inside the database UI

Buffer-local, in `dbui`, `dbout`, and DBUI-owned `sql` buffers.

| Key | Action | Defined in |
| --- | --- | --- |
| `=` | Grow the window by 5 (width for the tree, height for output) | `plugins/dbui.lua:57` |
| `-` | Shrink the window by 5 | `plugins/dbui.lua:52` |

These shadow the global `-` decrement mapping inside DBUI buffers only.

## Mappings that need a plugin that is not installed

Two mappings in `lua/config/keymaps.lua` reference tooling that this
configuration does not declare in any `lua/plugins/` spec and that is not present
in `lazy-lock.json`. Pressing them raises an error.

| Key | Mode | Calls | Defined in |
| --- | --- | --- | --- |
| `<C-A-r>` | n | `require("springboot-nvim").boot_run()` | `config/keymaps.lua:99` |
| `<C-A-l>` | n | `:JavaRunnerToggleLogs` | `config/keymaps.lua:100` |

To use them, add `elmcgill/springboot-nvim` (and a Java runner plugin) to
`lua/plugins/lsp/`. To remove the dead keys, delete those two lines.

## Related

- [How to change keymaps and options](../how-to/change-keymaps-and-options.md)
- [Options](options.md)
- [Plugins](plugins.md)
