# AGENTS.md

Neovim configuration repository using Lua. Contains modular plugin configs, LSP setup, and a shell installer.

## Verification Commands

```bash
# Test config loads without errors (headless)
nvim --headless -c 'q' 2>&1

# Test specific config file loads
nvim --headless -c 'lua require("config.04-lsp")' -c 'q' 2>&1

# Validate all Lua files parse correctly
lua -e 'for f in io.popen("find lua -name \"*.lua\""):lines() do assert(loadfile(f)) end; print("All Lua files valid")'

# Check installer script syntax
bash -n install.sh

# Full install test (clones to temp dir)
TMPDIR=$(mktemp -d) && git clone https://github.com/Ax-Time/nvim-config.git "$TMPDIR" && bash "$TMPDIR/install.sh" && rm -rf "$TMPDIR"
```

## Code Style

### General

- 2-space indentation, no tabs
- No trailing whitespace
- 80-char soft limit per line
- No comments unless explaining WHY (not what)
- Use `pcall(require(...))` when a plugin may not be installed

### File Structure

```
lua/config/
  00-init.lua     # General neovim settings (opt, g, global options)
  01-colors.lua   # Colorscheme and theme setup
  02-keymaps.lua  # Keybindings via vim.keymap.set
  03-plugins.lua  # lazy.nvim plugin spec
  04-lsp.lua      # LSP config via vim.lsp.config (NOT lspconfig)
  05-telescope.lua
  06-treesitter.lua
  07-cmp.lua      # nvim-cmp completion
  08-ui.lua       # which-key, gitsigns, and other UI plugins
```

### Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Config files | 2-digit prefix + kebab | `04-lsp.lua` |
| Variables | snake_case | `local opt = vim.opt` |
| Functions | snake_case | `local on_attach = function(...)` |
| Plugin specs | kebab-case for keys | `{ "nvim-telescope/telescope.nvim" }` |
| LSP servers | use mason names | `"lua_ls"`, `"ts_ls"` (NOT `"tsserver"`) |
| Keymap leaders | use `<leader>` | `vim.keymap.set("n", "<leader>lf", ...)` |

### Lua Patterns

**Option setting:**
```lua
local opt = vim.opt
opt.number = true
opt.expandtab = true
```

**Plugin spec:**
```lua
{ "author/repo", key = value }
{ "author/repo", dependencies = { "other/plugin" } }
{ "author/repo", build = ":TSUpdate", config = function() ... end }
```

**LSP config (modern, 0.11+):**
```lua
vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable('lua_ls')
```

**Keybinding:**
```lua
vim.keymap.set("n", "<leader>ff", vim.cmd.Telescope, { buffer = bufnr, remap = false })
```

**Conditional require:**
```lua
pcall(require, "optional-plugin")
```

### Error Handling

- Use `pcall(require(...))` for optional plugins
- Use `vim.defer_fn(function(), delay)` to defer plugin config loading until plugins are installed
- LSP setup in `on_attach` callback to ensure buffer context
- Wrap git clone in check: `if not vim.uv.fs_stat(path) then`

### Neovim-Specific

- Use `vim.opt` (not `vim.o` or `vim.go`) for options
- Use `vim.keymap.set` (not `vim.api.nvim_set_keymap`)
- Use `vim.lsp.config` + `vim.lsp.enable` (NOT `require('lspconfig')[server].setup`)
- Use `vim.defer_fn` for deferred execution
- Use `vim.fn.stdpath("data")` for plugin data paths
- Use `vim.cmd("colorscheme catppuccin")` for colorschemes

### Imports

```lua
local opt = vim.opt                           -- Options
local fn = vim.fn                             -- Functions
local cmd = vim.cmd                           -- Commands
local keymap = vim.keymap.set                 -- Keybindings (local alias)
local lsp = vim.lsp                           -- LSP API
```

## Repository Commands

```bash
# Commit all changes
git add -A && git commit -m "description"

# Push to remote
git push

# Create fresh feature branch
git checkout -b feat/description
```

## Working with lazy.nvim

Plugins are defined in `lua/config/03-plugins.lua` using lazy.nvim spec format. After editing:
```bash
nvim --headless +'lua vim.cmd("Lazy sync")' +qa
```

## Common Issues

- **Plugin config errors on fresh install**: Use `vim.defer_fn(..., 500)` to wait for lazy.nvim to install plugins
- **LSP server not found**: Use mason server names (`lua_ls`, not `sumneko_lua`)
- **Treesitter require error**: Use `require("nvim-treesitter")` not `require("nvim-treesitter.configs")`
