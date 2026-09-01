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

## Structure

```
init.lua                load order, lazy bootstrap
lua/config/             options, keymaps, autocmds, and modules lifted out of a spec
lua/plugins/<feature>/  plugin specs — ai, editor, git, lsp, ui
ftplugin/               per-filetype behavior
tests/                  headless specs
scripts/check           syntax, full config load, tests
```

Where a change belongs, and why the split works this way:
[Configuration structure](docs/structure.md).

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

## Validation

Run the project check before committing configuration changes:

```sh
scripts/check
```

It validates Lua syntax, loads the complete configuration in an isolated state
and cache directory, and runs the headless test suite. It does not install
plugins or modify your Neovim data directory.

## Customization

Every kind of change and where it goes:
[Configuration structure](docs/structure.md).

## License

Vimtellij is distributed under the [MIT License](LICENSE).
