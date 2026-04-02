# Neovim Config Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A production-ready Neovim configuration with one-command installer

**Architecture:** Modular Lua-based config with lazy.nvim plugin management. Installer is a POSIX shell script that bootstraps Neovim if needed and clones the repo to ~/.config/nvim.

**Tech Stack:** Neovim 0.9+, lazy.nvim, catppuccin, nvim-lspconfig, mason.nvim, telescope.nvim, nvim-cmp, treesitter, gitsigns.nvim, which-key.nvim

---

## File Structure

```
nvim-config/
├── README.md
├── install.sh
├── init.lua
└── lua/
    └── config/
        ├── 00-init.lua
        ├── 01-colors.lua
        ├── 02-keymaps.lua
        ├── 03-plugins.lua
        ├── 04-lsp.lua
        ├── 05-telescope.lua
        ├── 06-treesitter.lua
        ├── 07-cmp.lua
        └── 08-ui.lua
```

---

## Task 1: Create install.sh

**File:** `install.sh`

- [ ] **Step 1: Write the installer script**

```bash
#!/usr/bin/env bash
set -e

REPO_URL="${REPO_URL:-https://github.com/axtime/nvim-config}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_MIN_VERSION="0.9"

echo "Installing Neovim config from $REPO_URL"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)
            if command -v apt &>/dev/null; then echo "linux-apt"
            elif command -v dnf &>/dev/null; then echo "linux-dnf"
            elif command -v pacman &>/dev/null; then echo "linux-pacman"
            else echo "unsupported"
            fi
            ;;
        *) echo "unsupported" ;;
    esac
}

# Check/install Neovim
check_nvim() {
    if command -v nvim &>/dev/null; then
        local version=$(nvim --version | head -1 | grep -oP '\d+\.\d+' | head -1)
        if [ -n "$version" ]; then
            echo "Neovim $version found"
            return 0
        fi
    fi
    return 1
}

install_nvim() {
    local os=$1
    echo "Installing Neovim..."

    case $os in
        macos)
            if command -v brew &>/dev/null; then
                brew install neovim
            else
                echo "Error: Homebrew not found. Install from https://brew.sh"
                exit 1
            fi
            ;;
        linux-apt)
            sudo apt update && sudo apt install -y neovim
            ;;
        linux-dnf)
            sudo dnf install -y neovim
            ;;
        linux-pacman)
            sudo pacman -S --noconfirm neovim
            ;;
        *)
            echo "Error: Unsupported OS"
            exit 1
            ;;
    esac
}

# Main
OS=$(detect_os)
if [ "$OS" = "unsupported" ]; then
    echo "Error: Unsupported operating system"
    exit 1
fi

if ! check_nvim; then
    install_nvim "$OS"
fi

# Backup existing config
if [ -d "$CONFIG_DIR" ]; then
    BACKUP_DIR="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing config to $BACKUP_DIR"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

# Clone repo
echo "Cloning config to $CONFIG_DIR"
git clone "$REPO_URL" "$CONFIG_DIR"

# Install plugins
echo "Installing plugins..."
nvim --headless "+Lazy! sync" +qa

echo ""
echo "Installation complete! Run 'nvim' to start."
```

- [ ] **Step 2: Make script executable**

Run: `chmod + install.sh`

- [ ] **Step 3: Commit**

```bash
git add install.sh && git commit -m "feat: add install.sh one-command installer"
```

---

## Task 2: Create init.lua

**File:** `init.lua`

- [ ] **Step 1: Write init.lua**

```lua
-- Set up lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Source config files
require("config.00-init")
require("config.01-colors")
require("config.02-keymaps")
require("config.03-plugins")
require("config.04-lsp")
require("config.05-telescope")
require("config.06-treesitter")
require("config.07-cmp")
require("config.08-ui")
```

- [ ] **Step 2: Commit**

```bash
git add init.lua && git commit -m "feat: add init.lua entry point"
```

---

## Task 3: Create 00-init.lua

**File:** `lua/config/00-init.lua`

- [ ] **Step 1: Write general settings**

```lua
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.timeoutlen = 300
opt.undofile = true
opt.swapfile = false
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.wildmenu = true
opt.wildignore = "*.o,*.obj,*.pyc,*.class,*.build"
opt.completeopt = "menu,menuone,noinsert"
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false
opt.cmdheight = 1
opt.updatetime = 200
opt.redrawtime = 1500

vim.g.mapleader = " "
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/00-init.lua && git commit -m "feat: add 00-init.lua general settings"
```

---

## Task 4: Create 01-colors.lua

**File:** `lua/config/01-colors.lua`

- [ ] **Step 1: Write catppuccin setup**

```lua
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
  },
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = false,
    telescope = true,
    treesitter = true,
    which_key = true,
  },
})

vim.cmd("colorscheme catppuccin")
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/01-colors.lua && git commit -m "feat: add 01-colors.lua catppuccin setup"
```

---

## Task 5: Create 02-keymaps.lua

**File:** `lua/config/02-keymaps.lua`

- [ ] **Step 1: Write keybindings**

```lua
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>n", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>p", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open explorer" })

map("n", "<leader>tv", "<cmd>vsplit<cr><cmd>terminal<cr>", { desc = "Terminal vertical" })
map("t", "<esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

map("n", "<c-h>", "<c-w>h", { desc = "Window left" })
map("n", "<c-j>", "<c-w>j", { desc = "Window down" })
map("n", "<c-k>", "<c-w>k", { desc = "Window up" })
map("n", "<c-l>", "<c-w>l", { desc = "Window right" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/02-keymaps.lua && git commit -m "feat: add 02-keymaps.lua keybindings"
```

---

## Task 6: Create 03-plugins.lua

**File:** `lua/config/03-plugins.lua`

- [ ] **Step 1: Write plugin spec**

```lua
require("lazy").setup({
  { "folke/lazy.nvim", version = "*" },

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  { "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },

  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
})
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/03-plugins.lua && git commit -m "feat: add 03-plugins.lua lazy.nvim spec"
```

---

## Task 7: Create 04-lsp.lua

**File:** `lua/config/04-lsp.lua`

- [ ] **Step 1: Write LSP configuration**

```lua
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "tsserver",
    "rust_analyzer",
    "pyright",
    "gopls",
    "clangd",
  },
  automatic_installation = true,
})

local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end)

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/04-lsp.lua && git commit -m "feat: add 04-lsp.lua Mason + LSP config"
```

---

## Task 8: Create 05-telescope.lua

**File:** `lua/config/05-telescope.lua`

- [ ] **Step 1: Write Telescope configuration**

```lua
require("telescope").setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    winblend = 0,
    border = true,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    file_ignore_patterns = { "node_modules", ".git", "__pycache__", "target" },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = true,
    },
    live_grep = {
      theme = "ivy",
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/05-telescope.lua && git commit -m "feat: add 05-telescope.lua fuzzy finder config"
```

---

## Task 9: Create 06-treesitter.lua

**File:** `lua/config/06-treesitter.lua`

- [ ] **Step 1: Write Treesitter configuration**

```lua
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "javascript",
    "typescript",
    "tsx",
    "python",
    "rust",
    "go",
    "c",
    "cpp",
    "java",
    "html",
    "css",
    "json",
    "yaml",
    "markdown",
    "markdown_inline",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
})
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/06-treesitter.lua && git commit -m "feat: add 06-treesitter.lua syntax highlighting config"
```

---

## Task 10: Create 07-cmp.lua

**File:** `lua/config/07-cmp.lua`

- [ ] **Step 1: Write completion configuration**

```lua
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer", keyword_length = 3 },
  }),
  window = {
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind_icons = {
        Text = "󰦤",
        Method = "󰆧",
        Function = "󰆧",
        Constructor = "󰆧",
        Field = "󰜢",
        Variable = "󰀀",
        Class = "󰠱",
        Interface = "󰠱",
        Module = "󰆩",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "󰕧",
        Keyword = "󰌋",
        Snippet = "�办事处",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "󰕧",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "󰉽",
        Operator = "󰊕",
        TypeParameter = "󰅲",
      }
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "LSP",
        luasnip = "Snip",
        buffer = "Buf",
        path = "Path",
      })[entry.source.name]
      return vim_item
    end,
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/07-cmp.lua && git commit -m "feat: add 07-cmp.lua completion config"
```

---

## Task 11: Create 08-ui.lua

**File:** `lua/config/08-ui.lua`

- [ ] **Step 1: Write UI enhancements**

```lua
require("which-key").setup()

require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┋" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
  },
})
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/08-ui.lua && git commit -m "feat: add 08-ui.lua which-key and gitsigns"
```

---

## Task 12: Create README.md

**File:** `README.md`

- [ ] **Step 1: Write README**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add README.md && git commit -m "docs: add README with installation and usage"
```

---

## Spec Coverage Check

- [x] Installer works on macOS/Linux - Task 1
- [x] Neovim installs if missing - Task 1
- [x] Backup existing config - Task 1
- [x] Lazy.nvim plugin management - Task 6
- [x] Catppuccin theme - Task 4
- [x] LSP with Mason - Task 7
- [x] Telescope fuzzy finder - Task 5, Task 8
- [x] Treesitter - Task 9
- [x] nvim-cmp completion - Task 10
- [x] gitsigns - Task 11
- [x] which-key - Task 11
- [x] Keymaps - Task 5
- [x] General settings - Task 3
- [x] README with install command - Task 12

---

## Plan Complete

**Saved to:** `docs/superpowers/plans/2026-04-02-nvim-config-implementation.md`

**Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?
