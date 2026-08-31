# Vimtellij documentation

Documentation for this Neovim configuration: what it contains, how to change it,
and why it is shaped the way it is.

Start with [Architecture](explanation/architecture.md) if you are new to the
repository. Go straight to [Directory layout](reference/directory-layout.md) if
you are looking for a specific file.

## Reference

What the configuration contains, stated factually. These track the code; if one
of them disagrees with the source, the source is right and the doc is stale.

| Document | Covers |
| --- | --- |
| [Directory layout](reference/directory-layout.md) | Every file and directory, and what it owns |
| [Options](reference/options.md) | All 30 editor options and 2 globals, their values, and what each changes |
| [Keymaps](reference/keymaps.md) | All 91 mappings, grouped by task, with their source lines |
| [Plugins](reference/plugins.md) | All 36 plugin specs, their load triggers, and their configuration |
| [LSP and tools](reference/lsp-and-tools.md) | Language servers, Mason, Treesitter, formatters, ftplugins, external dependencies |
| [Theme and colors](reference/theme-and-colors.md) | The palette, who reads it, and every highlight override |

## How-to

Task recipes. Each one ends with a verification step and a troubleshooting
section.

| Document | For |
| --- | --- |
| [How to add a plugin](how-to/add-a-plugin.md) | Adding, configuring, or removing a plugin |
| [How to change keymaps and options](how-to/change-keymaps-and-options.md) | Changing a mapping, an option, or a color, and knowing it took |
| [How to run checks](how-to/run-checks.md) | Validating the config before committing, and adding a test |

## Explanation

Why the configuration is built this way. Read these when a decision looks odd
and you want the reasoning before changing it.

| Document | Covers |
| --- | --- |
| [Architecture](explanation/architecture.md) | Load order, the three directory rules, explicit imports, what the structure gives up |
| [Fold persistence](explanation/fold-persistence.md) | Why Markdown folds use a sidecar file and content anchors instead of `mkview` |

## Plans

Design documents for work that has not shipped yet.

| Document | Status |
| --- | --- |
| [Markdown 전용 링크 이동 구조화 계획](plans/20260821-markdown-gd-link-navigation-plan.md) | CEO PASS, spec pending. Korean. |

## Archive

Design records for work that shipped. Kept for the reasoning, not as a
description of current behavior. When one of these disagrees with a reference
doc, the reference doc is right.

| Document | Shipped in |
| --- | --- |
| [Markdown Fold Sidecar 영속성](archive/20260805-fold-sidecar-persistence-plan.md) | `333b51d`, `0ed25d2` |
| [Markdown fold sidecar Eng Review 테스트 계획](archive/20260807-fold-sidecar-eng-review-test-plan.md) | `333b51d` |
| [반복 가능한 Snacks Explorer 폭 토글](archive/explorer-width-toggle-design.md) | `dff24fa` |

## Known rough edges

Recorded here so they are not rediscovered. Each is documented in detail where
it belongs.

- `<leader>gd` is bound twice, in `plugins/snacks.lua` and `plugins/git/gitsigns.lua`. The buffer-local Gitsigns mapping wins. See [Keymaps](reference/keymaps.md#leadergd-is-bound-twice).
- `lua/config/keymaps.lua:99-100` map `<C-A-r>` and `<C-A-l>` to `springboot-nvim` and `:JavaRunnerToggleLogs`, neither of which this configuration installs. Both error on press. See [Keymaps](reference/keymaps.md#mappings-that-need-a-plugin-that-is-not-installed).
- `lua/plugins/ui/nvim-window-hightlighter.lua` has a typo in its filename.
- `typescript` has no ftplugin, so plain `.ts` files keep the global 4-space indent while `.tsx` gets 2. See [LSP and tools](reference/lsp-and-tools.md#filetype-overrides).
- `lua/config/theme.lua` hardcodes `#264F78` instead of reading `colors.lua`.

## Conventions

- Reference docs cite `file:line`. Those drift when code moves. `scripts/check` does not validate them; treat a mismatch as a doc bug and fix the doc.
- New reference and how-to documents go in English, matching the rest of this directory. Documents in `plans/` and `archive/` are Korean and stay as written.
- Every document links to its neighbours in a `Related` section at the bottom.
