# Neovim Config

A best-in-class Neovim configuration with lazy loading, LSP support, fuzzy finding, and more.

## Installation

Requires Neovim 0.9+ and curl.

```bash
curl -fsSL https://raw.githubusercontent.com/axtime/nvim-config/main/install.sh | bash
```

This will:
1. Install Neovim if not present (macOS via Homebrew, Linux via apt/dnf/pacman)
2. Backup your existing `~/.config/nvim` if present
3. Clone this repo to `~/.config/nvim`
4. Install all plugins

Then run `nvim` to start.

## Features

- **Lazy loading** via lazy.nvim for fast startup
- **LSP** via mason.nvim + nvim-lspconfig (auto-installs language servers)
- **Fuzzy finding** via telescope.nvim
- **Completion** via nvim-cmp with LSP snippets
- **Syntax highlighting** via treesitter
- **Git integration** via gitsigns.nvim
- **Keybinding hints** via which-key.nvim
- **Catppuccin** mocha theme

## Default Keymaps

| Keymap | Action |
|--------|--------|
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Find buffers |
| `<Space>fh` | Help tags |
| `<Space>w` | Write buffer |
| `<Space>q` | Quit |
| `<Space>n` | Next buffer |
| `<Space>p` | Previous buffer |
| `<Space>tv` | Terminal in vertical split |
| `Ctrl+h/j/k/l` | Navigate windows |
| `gd` | Go to definition |
| `gr` | Rename |
| `<Space>lf` | Format |

## Included Language Servers

- lua_ls
- tsserver (TypeScript)
- rust_analyzer
- pyright (Python)
- gopls (Go)
- clangd (C/C++)

## Customization

Edit files in `lua/config/`:
- `00-init.lua` - General settings
- `01-colors.lua` - Colorscheme
- `02-keymaps.lua` - Keybindings
- `03-plugins.lua` - Plugin list
- `04-lsp.lua` - LSP config
- `05-telescope.lua` - Fuzzy finder
- `06-treesitter.lua` - Syntax
- `07-cmp.lua` - Completion
- `08-ui.lua` - UI enhancements
