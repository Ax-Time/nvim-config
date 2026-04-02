# Neovim Config Design Spec

**Date:** 2026-04-02  
**Project:** Best-in-class Neovim configuration with one-command installer

---

## 1. Overview

A production-ready Neovim configuration packaged as a git repository with a shell installer that bootstraps Neovim itself and syncs plugins in one command.

**Install command:**
```bash
curl -fsSL <repo-url>/install.sh | bash
```

---

## 2. Repository Structure

```
nvim-config/
├── README.md
├── install.sh              # One-command installer
├── init.lua                # Main entry point (sources lua/config/*.lua)
└── lua/
    └── config/
        ├── 00-init.lua     # General neovim settings
        ├── 01-colors.lua   # Colorscheme (catppuccin mocha)
        ├── 02-keymaps.lua  # Keybindings
        ├── 03-plugins.lua  # Plugin definitions (lazy.nvim)
        ├── 04-lsp.lua      # LSP configuration (mason + lspconfig)
        ├── 05-telescope.lua # Fuzzy finder
        ├── 06-treesitter.lua # Syntax highlighting
        ├── 07-cmp.lua      # Autocompletion (nvim-cmp)
        └── 08-ui.lua       # UI (statusline, indent guides, etc.)
```

---

## 3. Installer Specification

**File:** `install.sh`

### Behavior

1. **OS Detection:** Support macOS (Intel + Apple Silicon) and Linux (apt, dnf, pacman)
2. **Neovim Check:** Verify `nvim` >= 0.9 is installed
3. **Neovim Installation:** If missing, install via system package manager:
   - macOS: `brew install neovim`
   - Linux apt: `apt install neovim`
   - Linux dnf: `dnf install neovim`
   - Linux pacman: `pacman -S neovim`
4. **Backup:** If `~/.config/nvim` exists, rename to `~/.config/nvim.bak`
5. **Clone:** Clone this repo to `~/.config/nvim`
6. **Plugin Sync:** Run `nvim --headless +Lazy sync +qa`
7. **Success:** Print instructions to launch neovim

### Exit Codes

- 0: Success
- 1: Unsupported OS
- 2: Package manager install failed

---

## 4. Plugin Stack

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager with lazy loading |
| catppuccin/nvim | Colorscheme (mocha flavor, dark) |
| nvim-lspconfig | LSPConfigs |
| mason.nvim | LSP/DAP/Linter/Formatter installer |
| telescope.nvim | Fuzzy finder (files, grep, buffers, LSP) |
| nvim-cmp | Completion engine |
| cmp-nvim-lsp | LSP source for nvim-cmp |
| treesitter | Syntax highlighting |
| gitsigns.nvim | Git status in gutter |
| which-key.nvim | Keybinding popup |

---

## 5. Key Configuration

### 5.1 General Settings (00-init.lua)

- Enable line numbers, relative numbers
- Enable mouse support
- Set clipboard to system clipboard
- Set timeoutlen to 300ms
- Enable filetype detection, syntax, indentation
- Set expandtab, shiftwidth=2, tabstop=2
- Enable undofile (persistent undo)
- Enable wildmenu, wildignore
- Set swapfile to ~/.config/nvim/swap (created if missing)

### 5.2 Keymaps (02-keymaps.lua)

Leader key: `<Space>`

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Telescope find_files |
| `<leader>fg` | Telescope live_grep |
| `<leader>fb` | Telescope buffers |
| `<leader>fh` | Telescope help_tags |
| `<leader>e` | Explore (netrw) |
| `<leader>w` | Write buffer |
| `<leader>q` | Quit |
| `<leader>n` | Next buffer |
| `<leader>p` | Previous buffer |
| `<leader>tv` | Open terminal in vertical split |
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>ld` | LSP goto definition |
| `<leader>lr` | LSP rename |
| `<leader>lf` | LSP format |

### 5.3 LSP (04-lsp.lua)

- Use mason.nvim to install servers
- Default servers: `lua_ls`, `tsserver`, `rust_analyzer`, `pyright`, `gopls`, `clangd`
- On_attach function: set keymaps, enable format on save
- Virtual text for diagnostics

### 5.4 Telescope (05-telescope.lua)

- Theme: Ivy or dropdown
- Default options: `find_files`, `live_grep`, `buffers`, `help_tags`
- File ignore patterns from .gitignore

### 5.5 Treesitter (06-treesitter.lua)

- Ensure install for: lua, vim, vimdoc, javascript, typescript, python, rust, go, c, cpp
- Enable indent for most languages
- incremental_selection mode

### 5.6 Completion (07-cmp.lua)

- Sources: nvim_lsp, buffer (path), cmp-telescope
- Snippet expansion with `vsnip` or `luasnip`
- Select first item with Enter

### 5.7 UI (08-ui.lua)

- Statusline: Use `mini.statusline` or `lualine.nvim`
- Indent guides: `mini.indentscope` or `indent-blankline.nvim`
- Enable word wrap
- Set completeopt to menu,menuone,noinsert

---

## 6. Colorscheme

**catppuccin mocha** (dark variant)

```lua
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
})
vim.cmd("colorscheme catppuccin")
```

---

## 7. Lazy Loading Strategy

Plugins load on first use via lazy.nvim spec:

- Most plugins: `{ "lazy", true }` or event = "VeryLazy"
- LSP plugins: event = "LspAttach"
- Treesitter: event = "BufReadPost"
- Telescope: event = "WinEnter" or lazy on command

---

## 8. Testing Checklist

- [ ] Installer works on macOS (Intel)
- [ ] Installer works on macOS (Apple Silicon)
- [ ] Installer works on Ubuntu/Debian
- [ ] Installer works on Fedora
- [ ] Installer works on Arch Linux
- [ ] Plugins install without errors
- [ ] Telescope finds files
- [ ] LSP works for at least one language (e.g., Lua)
- [ ] Colorscheme renders correctly
- [ ] Startup time < 500ms (without lazy loading optimization)

---

## 9. Success Criteria

1. One-command install works on any machine with curl
2. Neovim launches with no errors
3. LSP auto-installs language servers
4. Fuzzy finding works for files and grep
5. Git signs display in gutter
6. Catppuccin theme applies correctly
