# Options

Every editor option this configuration sets, with its value and effect. Thirty
`vim.opt` settings and two `vim.g` globals live in `lua/config/options.lua`, which `init.lua` loads first, before any
plugin.

"Neovim default" columns describe stock Neovim 0.11 so you can see what this
configuration actually changes.

## Line numbers and gutter

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `number` | `true` | `false` | Show absolute line numbers. |
| `relativenumber` | `true` | `false` | Show line numbers relative to the cursor. With `number` also on, the cursor line shows its absolute number and the rest are relative. |
| `numberwidth` | `2` | `4` | Minimum width of the number column. It grows past 2 when the file has more than 99 lines. |
| `signcolumn` | `"yes"` | `"auto"` | Always reserve one sign column. Prevents the text from shifting sideways when a Git sign or diagnostic appears. |

Source: `lua/config/options.lua:7-10`.

## Scrolling and wrapping

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `wrap` | `false` | `true` | Long lines run off the right edge instead of wrapping. |
| `scrolloff` | `10` | `0` | Keep 10 lines visible above and below the cursor. |
| `sidescrolloff` | `8` | `0` | Keep 8 columns visible left and right of the cursor. |

Source: `lua/config/options.lua:11-13`.

## Indentation

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `expandtab` | `true` | `false` | Insert spaces when you press `<Tab>`. |
| `shiftwidth` | `4` | `8` | Width of one indent level for `>>`, `<<`, and auto-indent. |
| `tabstop` | `4` | `8` | Display width of a literal tab character. |
| `softtabstop` | `4` | `0` | How many spaces `<Tab>` and `<BS>` move in insert mode. |
| `smartindent` | `true` | `false` | Indent the next line based on the previous one's syntax. |
| `breakindent` | `true` | `false` | Wrapped lines keep the indent of the original line. Only visible where `wrap` is on, which is not the global default here. |

Source: `lua/config/options.lua:16-21`.

These are the global values. Three filetypes override them to 2 spaces via
`ftplugin/`: Lua, JavaScript, and TypeScript React. See
[LSP and tools](lsp-and-tools.md#filetype-overrides).

## Files and persistence

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `backup` | `false` | `false` | No `~` backup file is kept after a write. |
| `writebackup` | `false` | `true` | No temporary backup during a write either. Slightly faster saves; a crash mid-write can lose the file. |
| `undofile` | `true` | `false` | Undo history survives closing the buffer, stored under `stdpath("state")/undo/`. |
| `fileencoding` | `"utf-8"` | `""` | Files are written as UTF-8. |

Source: `lua/config/options.lua:26`, `36`, `38`, `29`.

## Windows and splits

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `splitbelow` | `true` | `false` | `:split` puts the new window below. Pairs with the `ss` mapping. |
| `splitright` | `true` | `false` | `:vsplit` puts the new window to the right. Pairs with `sv`. |

Source: `lua/config/options.lua:32-33`.

## Interface

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `termguicolors` | `true` | `true` on most terminals | Enable 24-bit color. Required by the TokyoNight palette. |
| `cursorline` | `true` | `false` | Highlight the line the cursor is on. The folding config toggles this off while the cursor sits on a closed fold (`plugins/editor/folding.lua`). |
| `showmode` | `false` | `true` | Hide the `-- INSERT --` message. Lualine already shows the mode. |
| `mouse` | `"a"` | `"nvi"` | Mouse works in all modes, command-line included. |
| `conceallevel` | `0` | `0` | Never hide concealed text. Set explicitly so backticks stay visible in Markdown. Note that `render-markdown.nvim` raises this per-buffer for Markdown files. |
| `clipboard` | `"unnamedplus"` | `""` | Yank and paste go through the system clipboard by default. |

Source: `lua/config/options.lua:27-34`, `39`.

## Timing

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `timeoutlen` | `1000` | `1000` | Milliseconds to wait for the rest of a mapped sequence. Affects how long `s`, `g`, and `;` prefixes hang. |
| `updatetime` | `100` | `4000` | Milliseconds of idle before `CursorHold` fires and the swap file is written. The folding config uses `CursorHold` to auto-peek folds, so this value sets how fast that preview appears. |

Source: `lua/config/options.lua:35`, `37`.

## Search

| Option | Value | Neovim default | Effect |
| --- | --- | --- | --- |
| `hlsearch` | `true` | `true` | Highlight every match. `<Esc>` clears it (`keymaps.lua:41`). |
| `ignorecase` | `true` | `false` | Searches ignore case. |
| `smartcase` | `true` | `false` | Unless the pattern contains an uppercase letter, in which case the search is case-sensitive. Requires `ignorecase`. |

Source: `lua/config/options.lua:42-44`.

## Globals

| Global | Value | Effect |
| --- | --- | --- |
| `loaded_netrw` | `1` | Disable the builtin netrw file browser. Snacks explorer replaces it. |
| `loaded_netrwPlugin` | `1` | Disable the netrw plugin half. Both are needed to fully suppress it. |

Source: `lua/config/options.lua:24-25`.

## Options set elsewhere

Not every option lives in `options.lua`. These are set by plugin specs because
they only make sense alongside that plugin.

| Option | Value | Set in |
| --- | --- | --- |
| `foldcolumn` | `"1"` | `lua/plugins/editor/folding.lua:15` |
| `foldmethod` | `"manual"` | `lua/plugins/editor/folding.lua:16` |
| `foldlevel` | `99` | `lua/plugins/editor/folding.lua:17` |
| `foldlevelstart` | `99` | `lua/plugins/editor/folding.lua:18` |
| `foldenable` | `true` | `lua/plugins/editor/folding.lua:19` |
| `viewoptions` | appends `folds` | `lua/plugins/editor/folding.lua:20` |
| `sessionoptions` | appends `folds` | `lua/plugins/editor/folding.lua:21` |
| `viewdir` | `stdpath("state")/manual-fold-views//` | `lua/plugins/editor/folding.lua:22` |
| `mapleader` | `" "` | `lua/config/keymaps.lua:10` |

The fold options are in `init`, not `config`, so they apply during startup
before `nvim-ufo` loads. `foldmethod = "manual"` with `foldlevel = 99` means
nothing folds until you fold it yourself. See
[Fold persistence](../explanation/fold-persistence.md).

## Related

- [How to change keymaps and options](../how-to/change-keymaps-and-options.md)
- [Keymaps](keymaps.md)
- [Directory layout](directory-layout.md)
