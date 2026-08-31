# Theme and colors

The palette, who reads it, and every highlight group this configuration
overrides.

## The palette

`lua/config/colors.lua` returns a flat table of seven values. It has no logic
and no dependencies, so anything can `require` it without load-order concerns.

| Key | Value | Used for |
| --- | --- | --- |
| `accent` | `#2DD4BF` (teal) | Window separators, active window border, inline code text |
| `border` | `#0F766E` (dark teal) | Float borders, picker borders, code block borders |
| `dashboard_accent` | `#A1A1AA` (gray) | Every `SnacksDashboard*` group |
| `inactive` | `#52525B` (dim gray) | Window separator when Neovim loses focus |
| `none` | `NONE` | Transparency. The most-used value in the table. |
| `terminal` | `#000000` | Dashboard terminal background, notification background |
| `terminal_inline` | `#0B1220` (near-black blue) | Inline code background in Markdown |

`none` is the literal string `NONE`, which is how Neovim's highlight API means
"no color, let the terminal show through". It is not `nil`.

### Who reads the palette

Six files `require("config.colors")`:

| File | Uses |
| --- | --- |
| `lua/plugins/ui/theme.lua` | All seven keys, in `on_highlights` and `config` |
| `lua/plugins/snacks.lua` | `none`, `border` for picker highlights |
| `lua/config/snacks_dashboard.lua` | `dashboard_accent`, `none` |
| `lua/plugins/ui/notify.lua` | `terminal` |
| `lua/plugins/ui/nvim-window-hightlighter.lua` | `accent`, `inactive` |
| `lua/plugins/editor/folding.lua` | `none` |

Change a hex value in `colors.lua` and every one of them follows on the next
restart. That is the point of the file.

## Colorscheme

`folke/tokyonight.nvim`, style `night`, loaded with `priority = 1000` so it wins
against any other startup plugin that sets highlights.

Source: `lua/plugins/ui/theme.lua`.

| Option | Value | Effect |
| --- | --- | --- |
| `style` | `"night"` | The darkest TokyoNight variant. |
| `transparent` | `true` | Use the terminal background instead of painting one. |
| `terminal_colors` | `true` | Apply the palette to `:terminal` buffers. |
| `styles.sidebars` | `"transparent"` | Explorer and other sidebars show the terminal through. |
| `styles.floats` | `"transparent"` | Same for float windows. |
| `styles.comments.italic` | `false` | Comments are not italic. |
| `styles.keywords.italic` | `false` | Keywords are not italic. |

## Highlight overrides

Three layers write highlights, and they run in this order.

### 1. `on_highlights`, at colorscheme setup

TokyoNight calls this while building its highlight table
(`lua/plugins/ui/theme.lua:22`). Applies once per `:colorscheme` call.

| Group | Override |
| --- | --- |
| `Normal`, `NormalNC`, `NormalFloat` | `bg = NONE` |
| `FloatBorder` | `fg = border`, `bg = NONE` |
| `FloatTitle`, `SignColumn`, `EndOfBuffer` | `bg = NONE` |
| `WinSeparator` | `fg = accent`, `bg = NONE` |
| `SnacksDashboardTerminal` | `bg = terminal` |
| `RenderMarkdownH1Bg` … `H6Bg` | `bg = NONE` |
| `RenderMarkdownCode` | `bg = NONE` |
| `RenderMarkdownCodeBorder` | `fg = border`, `bg = NONE` |
| `RenderMarkdownCodeInfo` | `bg = NONE` |
| `RenderMarkdownCodeInline` | `fg = accent`, `bg = terminal_inline`, bold |

### 2. `config`, after `:colorscheme`

Two functions run immediately and again on `ColorScheme` and `VimEnter`
(`lua/plugins/ui/theme.lua:85-101`).

`clear_markdown_backgrounds()` re-clears the Markdown groups plus four
Treesitter capture groups that `on_highlights` cannot reach, because
`render-markdown` and the Treesitter markdown parser both set them after the
colorscheme is applied:

- `@markup.raw`
- `@markup.raw.block`
- `@markup.raw.block.markdown`
- `@markup.raw.markdown_inline` (gets `fg = accent`, bold)

`force_black_terminal()` sets `terminal_color_0` and `terminal_color_8` to
`terminal`, then walks every window and applies a `winhighlight` remap to any
float whose buffer filetype is `snacks_dashboard`. It also fires on the
`SnacksDashboardOpened` and `SnacksDashboardUpdatePost` user events, deferred
20 ms, because the dashboard creates its terminal window after the event.

### 3. Per-plugin, in each plugin's own spec

| Plugin | Groups | Reapplied on |
| --- | --- | --- |
| `snacks.nvim` | 12 `Snacks*` groups: `SnacksNormal`, `SnacksNormalNC`, `SnacksWinSeparator`, `SnacksPicker`, `SnacksPickerInput`, `SnacksPickerList`, `SnacksPickerPreview`, `SnacksPickerBorder`, `SnacksPickerInputBorder`, `SnacksPickerListBorder`, `SnacksPickerPreviewBorder`, `SnacksPickerTitle` | `ColorScheme`, `VimEnter` |
| `config/snacks_dashboard.lua` | 8 `SnacksDashboard*` groups, all `fg = dashboard_accent` | `ColorScheme`, `VimEnter`, `SnacksDashboardOpened`, `SnacksDashboardUpdatePost` |
| `nvim-ufo` (`editor/folding.lua`) | `Folded`, `UfoFoldedBg`, `UfoPreviewWinBar`, `UfoPreviewCursorLine`, `UfoCursorFoldedLine`, all `bg = NONE` | `ColorScheme`, `VimEnter` |
| `colorful-winsep.nvim` | `ColorfulWinSep` | `ColorScheme`, `FocusLost`, `FocusGained` |
| `config/theme.lua` | `Visual`, `VisualNOS`, `bg = #264F78` | `ColorScheme` |

Every layer reattaches to `ColorScheme`. That is deliberate: running
`:colorscheme` at runtime, or a plugin doing it, would otherwise wipe these
overrides.

`lua/config/theme.lua` is the one override not driven by `colors.lua`. Its
`#264F78` is hardcoded, matching the VS Code Dark+ selection color. Moving it
into the palette would be a reasonable cleanup.

## Dynamic highlights

Two places create highlight groups at runtime instead of declaring them.

`lua/config/snacks_dashboard.lua:13-28` builds a `MilliSplash_<fg>_<bg>` group
per color pair the splash animation needs, cached by key so a repeated pair
reuses one group. The animation has per-frame color runs, so declaring them
statically is not possible.

`lua/plugins/ui/nvim-window-hightlighter.lua:20-26` recomputes `ColorfulWinSep`
on every focus change, reading the current `Normal` background so the separator
sits on whatever the colorscheme is using.

## Markdown checkbox highlights

The six custom checkbox states in `lua/plugins/editor/markdown.lua` reuse
existing diagnostic groups rather than defining their own. See
[Plugins](plugins.md#checkbox-states) for the table.

`[~]` is the only one whose highlight extends past the marker.
`lua/config/markdown_task_scope.lua` wraps `render-markdown`'s builtin handlers
and rewrites their marks so the whole `list_item` subtree, virtual-text icons
included, is painted `Comment` at priority 200 (above Treesitter's 100).

## Changing the theme

To recolor without touching plugin specs, edit `lua/config/colors.lua`. To swap
the colorscheme entirely, replace the `tokyonight.nvim` spec in
`lua/plugins/ui/theme.lua` and keep the `config` function: the
`clear_markdown_backgrounds` and `force_black_terminal` callbacks are
colorscheme-independent.

## Related

- [Plugins](plugins.md)
- [Directory layout](directory-layout.md)
- [Architecture](../explanation/architecture.md)
