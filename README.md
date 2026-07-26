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
- Folding preview and fold persistence
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

## Project structure

```text
.
├── init.lua                    # Bootstrap lazy.nvim and load configuration
├── ftplugin/                   # Filetype-local options and Java LSP startup
├── lua/
│   ├── config/                 # Options, keymaps, autocmds, theme, and modules
│   │   └── snacks/             # Snacks picker, explorer, dashboard, Lazygit
│   └── plugins/                # Lazy.nvim specs grouped by feature
│       ├── ai/
│       ├── editor/
│       ├── git/
│       ├── lsp/
│       └── ui/
├── scripts/check               # Syntax and full configuration smoke check
├── lazy-lock.json              # Pinned plugin revisions
├── stylua.toml                 # Lua formatter configuration
└── LICENSE                     # MIT License
```

## Useful keymaps

The leader key is `Space`.

| Key | Action |
| --- | --- |
| `ss` | Horizontal split |
| `sv` | Vertical split |
| `sh` / `sj` / `sk` / `sl` | Resize the current window |
| `<leader>e` | Open Snacks explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Search project text |
| `<leader>gg` | Open Lazygit |
| `<leader>gd` | Show the current Git diff |
| `<leader>ghb` | Show Git blame for the current buffer |
| `<leader>gflh` | Show history for a selected line range |
| `<leader>cf` | Format the current buffer or selection |
| `K` | Hover documentation or folded-line preview |

Plugin-specific mappings are defined next to their plugin specification and
can be changed in `lua/config/keymaps.lua` or the relevant file under
`lua/plugins/`.

## Validation

Run the project check before committing configuration changes:

```sh
scripts/check
```

The check validates Lua syntax and loads the complete Neovim configuration in
an isolated state and cache directory. It does not install plugins or modify
the user's Neovim data directory.

## Customization

- Change editor-wide options in `lua/config/options.lua`.
- Change mappings in `lua/config/keymaps.lua`.
- Change shared UI colors in `lua/config/colors.lua`.
- Add or override plugins in the appropriate `lua/plugins/` feature directory.
- Add filetype-specific behavior under `ftplugin/`.

Keep plugin configuration close to the plugin spec so lazy-loading behavior and
dependencies remain easy to understand.

## License

Vimtellij is distributed under the [MIT License](LICENSE).
