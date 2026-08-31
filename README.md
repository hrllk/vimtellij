# Vimtellij

An opinionated Neovim configuration for software development, focused on a
fast editor workflow, practical LSP defaults, Git tooling, and a clean UI.

## Features

- `lazy.nvim` plugin management with feature-based plugin directories
- LSP support for Lua, Go, TypeScript, and Java
- Completion with `nvim-cmp` and LuaSnip
- Treesitter syntax highlighting and language-aware editing
- Git signs, hunk navigation, staging, diffs, and blame
- Snacks explorer, picker, dashboard, and Lazygit integration
- Formatting and diagnostics through None-ls, Stylua, Prettier, and ESLint
- Folding preview, plus Markdown fold state that syncs through Git
- Markdown rendering and preview support
- Shared UI color palette for consistent theme customization

## Requirements

- Neovim 0.11 or newer
- Git
- A Nerd Font for icons used by several UI plugins
- `ripgrep` for the project check script and Snacks picker search

Optional tools are installed or detected by the configuration when available:

- Lua Language Server and `gopls` through Mason
- Node.js and npm for TypeScript language-server support
- Java, JDTLS, and Lombok for Java development
- `jq` for JSON formatting
- `curl` or `wget`, plus Yarn, for Markdown preview installation

The full list, and what breaks without each one, is in
[LSP and tools](docs/reference/lsp-and-tools.md#external-tools-this-configuration-expects).

## Installation

Back up an existing Neovim configuration if needed:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

Clone the configuration:

```sh
git clone https://github.com/hrllk/vimtellij.git ~/.config/nvim
```

Start Neovim and allow `lazy.nvim` to install the configured plugins:

```sh
nvim
```

## Documentation

Full documentation lives in [`docs/`](docs/README.md).

**Reference**

- [Directory layout](docs/reference/directory-layout.md) — every file and what it owns
- [Options](docs/reference/options.md) — all editor options and their effects
- [Keymaps](docs/reference/keymaps.md) — every mapping, with its source line
- [Plugins](docs/reference/plugins.md) — all 36 plugin specs and their load triggers
- [LSP and tools](docs/reference/lsp-and-tools.md) — servers, Mason, Treesitter, formatters
- [Theme and colors](docs/reference/theme-and-colors.md) — the palette and highlight overrides

**How-to**

- [Add a plugin](docs/how-to/add-a-plugin.md)
- [Change keymaps and options](docs/how-to/change-keymaps-and-options.md)
- [Run checks](docs/how-to/run-checks.md)

**Explanation**

- [Architecture](docs/explanation/architecture.md) — load order and why the directories split this way
- [Fold persistence](docs/explanation/fold-persistence.md) — why Markdown folds work differently

## Getting around

The leader key is `Space`. A few to start with:

| Key | Action |
| --- | --- |
| `<leader>e` | Open the file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Search project text |
| `<leader>gg` | Open Lazygit |
| `<leader>cf` | Format the buffer or selection |
| `<leader>?` | Show buffer-local keymaps |
| `K` | Hover documentation, or fold preview on a closed fold |

All 91 mappings, including which file defines each one, are in
[Keymaps](docs/reference/keymaps.md).

## Validation

Run the project check before committing configuration changes:

```sh
scripts/check
```

It validates Lua syntax, loads the complete configuration in an isolated state
and cache directory, and runs the headless test suite. It does not install
plugins or modify your Neovim data directory. See
[How to run checks](docs/how-to/run-checks.md).

## Customization

Start with [Change keymaps and options](docs/how-to/change-keymaps-and-options.md),
which covers where each kind of change belongs and how to verify it took effect.

The short version:

- Editor-wide options → `lua/config/options.lua`
- Mappings not tied to a plugin → `lua/config/keymaps.lua`
- Shared UI colors → `lua/config/colors.lua`
- Anything belonging to a plugin → that plugin's spec under `lua/plugins/`
- Filetype-specific behavior → `ftplugin/`

Keep plugin configuration next to the plugin spec, so lazy-loading behavior and
dependencies stay easy to follow, and deleting a plugin deletes its keymaps with
it. The reasoning is in [Architecture](docs/explanation/architecture.md).

## License

Vimtellij is distributed under the [MIT License](LICENSE).
