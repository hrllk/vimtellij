# Vimtellij

A modern, fast, and extensible Neovim distribution built on top of the LazyVim ecosystem.  
Vimtellij provides an opinionated but flexible setup with clean defaults, powerful workflows, and a fully customizable plugin architecture.

This project is a fork of [LazyVim](https://github.com/LazyVim/LazyVim) and includes several enhancements, presets, and developer-friendly defaults tailored for real-world software engineering workflows.

> Powered by **Neovim**, **lazy.nvim**, and an ecosystem of high-quality plugins.


## Features

- **Fast startup** powered by `lazy.nvim`
- **Modular plugin architecture**
- **Clean UI / UX** with sensible defaults
- **Better coding experience** (LSP, autocomplete, formatting)
- **Custom language presets** (Java, Python, Go, JS, etc.)
- **Built-in Git integration** (lazygit, diffview, gitsigns)
- **REST API testing workflow** (rest.nvim)
- **Flexible plugin overriding system**
- **Easy to extend** — add or override any plugin in `lua/plugins`


## Installation

### 1) Backup your existing Neovim config

```sh
$ mv ~/.config/nvim ~/.config/nvim.backup
$ mv ~/.local/share/nvim ~/.local/share/nvim.backup
```


### 2) Install GuardianVim
``` sh
$ git clone https://github.com/YOUR_USERNAME/YOUR_REPO ~/.config/nvim
```

### 3) Start Neovim
``` sh
$ nvim
```


## Directory Structure

``` text
~/.config/nvim
 ├─ init.lua
 ├─ lua/
 │   ├─ core/
 │   ├─ config/
 │   ├─ plugins/
 │   │   ├─ editor.lua
 │   │   ├─ git.lua
 │   │   ├─ lang/
 │   │   │   ├─ java.lua
 │   │   │   └─ python.lua
 │   │   └─ ui.lua
 │   └─ utils/
 └─ README.md

```

## License
This project includes source code from LazyVim (MIT License).
You may use, modify, and redistribute this project under the terms of the MIT License.

See the [LICENSE](https://opensource.org/license/mit)
