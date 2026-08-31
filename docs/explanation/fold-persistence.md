# Fold persistence

Why this configuration keeps fold state two different ways, and why Markdown
gets the complicated one.

## The problem

Manual folds do not survive closing a buffer. Neovim's answer is `:mkview`,
which writes a view file to `viewdir` recording the current fold state, and
`:loadview`, which replays it. This configuration wires both to `BufWinLeave`
and `BufWinEnter` (`lua/plugins/editor/folding.lua:113-133`), with `viewdir` set
to `stdpath("state")/manual-fold-views//`.

That works for code. It does not work for the case this configuration actually
cares about: a long-lived Markdown note, edited from more than one machine,
tracked in Git.

Two things break.

**View files are machine-local.** They live under `stdpath("state")`, outside
the repository. Fold a section of a note on your laptop, pull the repo on
another machine, and the folds are gone. There is nothing to sync, and syncing
`stdpath("state")` would drag along unrelated view files for every file you have
ever opened.

**View files address folds by line number.** A view records "lines 40 to 78 are
folded." Insert a paragraph at line 10, and every fold below it now points at
the wrong text. In a note you append to daily, that is not an edge case, it is
Tuesday.

The obvious fix, fold markers (`{{{` and `}}}` in the text with
`foldmethod=marker`), solves both problems and creates a worse one: it edits the
document. A Markdown file with fold markers in it renders wrong everywhere else,
on GitHub, in a preview pane, in any other editor.

So the requirement is: fold state that travels with the document, survives edits
above it, and does not touch a single byte of the document itself.

## The approach

Store fold state in a **sidecar file** next to the document, and address each
fold by **the text of its first and last line** rather than by line number.

```
Areas/PER-LOG-2026.md              the document, unmodified
Areas/.PER-LOG-2026.md.folds.json  the sidecar
```

The sidecar is a dotfile in the same directory, so it commits alongside the
document and travels through Git without any extra machinery.

### What a sidecar holds

```json
{
  "version": 2,
  "source": "PER-LOG-2026.md",
  "folds": [
    {
      "start": { "text": "## 2026-08", "occurrence": 1 },
      "end":   { "text": "- 마지막 항목", "occurrence": 3 },
      "state": "closed"
    }
  ]
}
```

Each entry names the fold's boundaries by content. `occurrence` disambiguates:
if three lines in the document read `- 마지막 항목`, this is the third.

Restoring a fold means searching the current document for the first line with
that text and that occurrence index, doing the same for the end, and folding the
range between them. Insert a hundred lines above, and the anchors still resolve
to the same content.

### Anchor normalization

Two lines count as the same anchor when their **normalized** text matches:
leading and trailing whitespace stripped, internal whitespace runs collapsed to
one space (`folding_anchor.lua:3-9`).

Reindenting a list item does not break its fold. Rewording it does, deliberately:
a fold whose boundary text changed no longer describes a range the user chose.

Some lines can never be anchors (`folding_anchor.lua:11-14`):

- Blank lines
- Horizontal rules (`---`, `***`, `___`, and mixed variants)

Both appear too often to identify anything. When a selected range starts or ends
on one, `capture` walks inward to the first line that is usable
(`folding_anchor.lua:40-70`). The fold you get back is anchored on real content,
even if you selected a blank line at the edge.

### Module split

```
folding_anchor.lua     pure text. no Neovim API at all.
        ▲
        │ required by
        │
folding_sidecar.lua    buffer <-> JSON file. read, write, upsert, restore.
        ▲
        │ required by
        │
folding_adapter.lua    the zo behavior
        ▲
        │ required by
        │
plugins/editor/folding.lua   autocmds, keymaps, nvim-ufo setup
```

`folding_anchor.lua` calls no Neovim function. That is what makes
`tests/folding_anchor_spec.lua` runnable under `nvim --headless -u NONE -l`,
with no plugins, no config, and no buffer. Anchor resolution is the part most
likely to be wrong, and it is the part that is cheapest to test.

## Two strategies, one predicate

Which mechanism a buffer gets is decided by one function:

```lua
function M.is_markdown(bufnr)
  return vim.bo[bufnr].buftype == ""
    and vim.bo[bufnr].filetype == "markdown"
    and M.path(bufnr) ~= nil
end
```

Everything routes off it.

| | Markdown | Everything else |
| --- | --- | --- |
| Storage | `.<name>.md.folds.json`, next to the file | `stdpath("state")/manual-fold-views/` |
| Addressing | Line text + occurrence | Line number |
| Travels with the repo | Yes | No |
| Survives edits above the fold | Yes | No |
| `zf` in visual mode | Fold and write the sidecar | Builtin |
| `zo` | Open the fold and drop its entry | Builtin |

`should_persist` in the spec (`lua/plugins/editor/folding.lua:107`) is the
inverse: `mkview` runs only when `is_markdown` is false. The two never both fire
on the same buffer.

Non-Markdown files keep `mkview` because it is free, already works, and code
files are usually opened at a stable point in their history. The Markdown
machinery is not better in general, it is better for one specific situation.

## Design decisions worth knowing

### Nothing is written until you fold something

Opening a Markdown file creates no sidecar. The write path is only reached from
`zf` (`upsert`) and `zo` (`remove_for_range`).

Without that rule, opening a directory of notes to read them would litter every
one with a `.folds.json`. Read-only use leaves no trace.

### Writes are atomic

`M.write` writes to `<path>.tmp.<pid>` and renames it over the target
(`folding_sidecar.lua:67-89`). A crash mid-write leaves the previous sidecar
intact rather than a half-written JSON file. On failure the temp file is
deleted, and the caller warns through `warn_write_failure`.

### Partially overlapping folds are refused, not merged

Two folds may nest, or be disjoint. They may not partially overlap
(`folding_anchor.lua:99-104`).

Neovim's manual folds cannot represent a partial overlap, so a sidecar
containing one has no valid restoration. Rather than pick an arbitrary
resolution, `upsert` returns `nil` and refuses the write, and `restore` skips
the conflicting entry with a debug notification. State stays representable at
all times.

### `version` and `source` guard the file

`read` rejects a sidecar whose `version` is not 2 or whose `source` does not
match the current buffer's basename (`folding_sidecar.lua:26-31`).

The version check means a future format change degrades to "no folds restored"
instead of misapplying old data. The `source` check catches a sidecar left
behind after a rename, where the anchors would resolve against a document they
were not written for.

### Restoring goes bottom-up

`restore` sorts resolved ranges by descending start line before folding
(`folding_sidecar.lua:172-174`).

Creating a fold does not renumber lines, but it does close them, and folding an
outer range first hides the lines an inner range needs to address. Working
upward from the bottom means every range is still open when its turn comes.

### A guard flag prevents self-erasure

`restore` runs inside a `vim.schedule` on `BufWinEnter`, and sets
`vim.b[buf].fold_sidecar_restoring = true` around itself
(`lua/plugins/editor/folding.lua:149-151`).

`folding_adapter.open_markdown_fold` checks that flag before calling
`remove_for_range`. Without it, any fold opened during restoration would delete
its own sidecar entry, and the file would quietly lose its folds over a few
sessions.

## Trade-offs

**A dotfile per folded document.** `.PER-LOG-2026.md.folds.json` sits next to
the note and shows up in `git status`. That is the cost of Git-syncable state.
Adding it to `.gitignore` gives back local-only folds and defeats the purpose.

**Rewording a boundary line loses the fold.** Anchors are content. Change the
content and the anchor no longer matches; the entry is skipped with a debug
message and the section opens. This is a deliberate choice over fuzzy matching,
which would sometimes restore a fold over the wrong range, a failure that is
harder to notice than a missing fold.

**Duplicate lines rely on a stable occurrence count.** A document with many
identical lines addresses folds by "the Nth occurrence." Inserting another copy
of that line above shifts every later index. In practice the boundary lines of a
fold are headings and distinctive items, not repeated boilerplate, so this
rarely bites, but it is a real limit.

**Two mechanisms, twice the surface.** Fold behavior in Markdown is not the same
as fold behavior in Lua. Anyone reading the config has to learn both. The four
test files exist to keep the Markdown half honest.

## Alternatives considered

From the design record in `docs/archive/20260805-fold-sidecar-persistence-plan.md`:

| Alternative | Why not |
| --- | --- |
| Fold markers in the text | Modifies the document. Renders as noise on GitHub and in every other editor. |
| `mkview` for Markdown too | Machine-local, and line numbers break on any edit above a fold. |
| Line numbers in the sidecar | Fixes syncing, not editing. Any insertion above a fold shifts it. |
| Byte offsets | Worse than line numbers. Any edit at all invalidates them. |
| Treesitter node paths | Survives some edits, but a Markdown tree changes shape when a heading level changes, and the failure is silent. |

The full record, plus the test plan that shipped with it, is in
[`docs/archive/`](../archive/20260805-fold-sidecar-persistence-plan.md).

## Related

- [Keymaps](../reference/keymaps.md#folding) — `zf`, `zo`, `zR`, `zM`
- [Options](../reference/options.md#options-set-elsewhere) — the eight fold options
- [Directory layout](../reference/directory-layout.md) — where the modules live
- [Architecture](architecture.md) — why they are separate modules at all
