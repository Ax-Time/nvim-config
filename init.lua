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