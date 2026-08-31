# How to run checks

Validate the configuration before committing, so a broken change does not follow
you to the next machine.

## Prerequisites

- `ripgrep` on `PATH` (`scripts/check` uses `rg --files` to enumerate Lua files)
- Neovim 0.11 or newer
- No plugin installation required. The check runs against isolated state and
  cache directories and never touches your Neovim data directory.

## Steps

### 1. Run it

From the config root:

```sh
scripts/check
```

### 2. Read the output

A passing run takes about a second and looks like this:

```
Checking Lua syntax...
Loading Neovim configuration...
Running headless fold tests...
theme_highlight_spec: all assertions passedfolding_anchor_spec: all assertions passedMarkdown fold sidecar: invalid sidecar format; skipping restore
Markdown fold sidecar: invalid sidecar format; skipping restore
Markdown fold sidecar: invalid sidecar format; skipping restore
folding_sidecar_spec: all assertions passedfolding_adapter_smoke: all assertions passedAll checks passed
```

The last line is the one that matters. `All checks passed` means every stage
succeeded; the script exits non-zero on any failure.

Two things in that output look like problems and are not:

- **`Markdown fold sidecar: invalid sidecar format; skipping restore`**, three
  times. That is `folding_sidecar_spec.lua` deliberately feeding malformed JSON
  to `M.read` and asserting it is rejected. The message is the module doing its
  job.
- **Missing line breaks between test names.** The specs print without a trailing
  newline, so `theme_highlight_spec: all assertions passed` runs straight into
  the next one. Cosmetic.

## What each stage does

### Stage 1: Lua syntax

```sh
nvim --headless -n -u NONE "+lua assert(loadfile('<file>'))" +qa!
```

Runs `loadfile` on every `.lua` file under `lua/` and `ftplugin/`, one Neovim
process each. `-u NONE` means no configuration is loaded, so this checks parsing
only, not whether the code works.

Catches: a missing `end`, an unbalanced brace, a stray character.

### Stage 2: Full configuration load

```sh
nvim --headless -n -u "$ROOT/init.lua" +qa!
```

Loads the real `init.lua` with `XDG_STATE_HOME` and `XDG_CACHE_HOME` pointed at
a temporary directory, so nothing leaks into your actual Neovim state.

The output is captured to a log and then scanned:

```sh
rg -n "Error|Failed to run|E[0-9]{3}:" "$LOG"
```

A match fails the check even when Neovim itself exited 0. That matters: a
plugin's `config` function can throw, `lazy.nvim` catches it and reports it, and
Neovim still quits cleanly. Without the log scan, a broken plugin would pass.

Catches: a `require` of a module that does not exist, a nil index during setup, a
plugin whose `setup()` rejects your options.

Note this stage installs nothing. Plugins already cloned into your real
`stdpath("data")` are still found, because only state and cache are redirected.
On a machine where plugins are not installed yet, this stage exercises
`lazy.nvim`'s bootstrap path instead.

### Stage 3: Headless tests

```sh
nvim --headless -n -u NONE -l tests/<file>.lua
```

Four test files, run in a fixed order:

| File | Covers |
| --- | --- |
| `theme_highlight_spec.lua` | Palette-driven highlight groups resolve as expected |
| `folding_anchor_spec.lua` | Anchor normalization, occurrence lookup, overlap detection |
| `folding_sidecar_spec.lua` | Sidecar read and write, version validation, entry removal |
| `folding_adapter_smoke.lua` | `zo` opens the fold and drops the right entry |

They are plain Lua with `assert`, not a test framework. A failure prints the
assertion message and a stack trace, and the script stops there (`set -e`).

`-u NONE` means these run with no configuration at all. That is possible because
`folding_anchor.lua` calls no Neovim API, and the other three modules take a
buffer number rather than reaching for global state. See
[Fold persistence](../explanation/fold-persistence.md#module-split).

## When to run it

- Before every commit that touches `lua/`, `ftplugin/`, or `init.lua`
- After adding or removing a plugin
- After pulling changes from another machine
- Before reporting that something is broken, so you know whether it is your
  change or the environment

## Adding a test

Create `tests/<name>_spec.lua`. It must run under `nvim --headless -u NONE -l`,
so it cannot depend on any plugin.

```lua
-- Required preamble. `-u NONE` means the config's lua/ is not on package.path,
-- so a require("config.*") fails without this. Copy it verbatim.
local test_file = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p")
local repo_root = test_file:match("^(.*)/tests/")
package.path = repo_root .. "/lua/?.lua;" .. repo_root .. "/lua/?/init.lua;" .. package.path

local anchor = require("config.folding_anchor")

assert(anchor.normalize("  a   b  ") == "a b", "normalize collapses whitespace")

print("your_new_spec: all assertions passed")
```

All four existing specs open with those three lines. Keep the
`vim.fn.fnamemodify(..., ":p")` call: three of the specs omit it and work only
because `scripts/check` invokes them with an absolute path. Drop it and running
`nvim --headless -u NONE -l tests/your_spec.lua` from the config root fails with
`attempt to concatenate local 'repo_root' (a nil value)`.

Then add it to the loop in `scripts/check`:

```sh
for test_file in \
  "$ROOT/tests/theme_highlight_spec.lua" \
  "$ROOT/tests/folding_anchor_spec.lua" \
  "$ROOT/tests/folding_sidecar_spec.lua" \
  "$ROOT/tests/folding_adapter_smoke.lua" \
  "$ROOT/tests/your_new_spec.lua"; do
```

The list is explicit, not a glob. A file you forget to add is silently never
run.

Match the existing print format, `<name>: all assertions passed`, so a passing
run stays readable.

## Troubleshooting

**`rg: command not found`**
Install ripgrep. Stage 1 enumerates files with `rg --files` and stage 2 scans the
log with it.

```sh
brew install ripgrep
```

**Stage 1 fails and names a file.**
A syntax error in that file. The message includes the line. Fix and rerun.

**Stage 2 prints a wall of log output.**
That is the captured log being dumped because the check failed. Read the first
error, not the last; later ones are usually consequences of the first. `lazy.nvim`
prefixes plugin failures with the plugin name.

**Stage 2 fails only on a fresh machine.**
Plugins are not installed yet, so `lazy.nvim` is cloning during the run. Start
Neovim once normally, let it finish installing, then rerun.

**A fold test fails after you changed nothing in `lua/config/folding_*`.**
Check whether `render-markdown.nvim` or `nvim-ufo` updated. The tests exercise
this configuration's own modules, but `folding_adapter_smoke.lua` touches real
buffer folding, so a Neovim version change can move it.

**The check passes but Neovim is still broken interactively.**
Stage 2 quits immediately with `+qa!`, so anything triggered by `VeryLazy`,
`BufReadPre`, `InsertEnter`, or a keypress never runs. The check covers load
errors, not runtime behavior. Reproduce interactively and use `:messages` and
`:Lazy` to narrow it down.

## Related

- [How to add a plugin](add-a-plugin.md)
- [How to change keymaps and options](change-keymaps-and-options.md)
- [Fold persistence](../explanation/fold-persistence.md) — what the fold tests protect
- [Directory layout](../reference/directory-layout.md#tests--headless-specs)
