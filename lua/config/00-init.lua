local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.timeoutlen = 300
opt.undofile = true
opt.swapfile = false
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
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
