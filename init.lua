-- Set up lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- Setup plugins
require("config.03-plugins")

-- Load non-plugin-dependent configs
require("config.00-init")
require("config.02-keymaps")

-- Defer loading plugin configs to give lazy.nvim time to install
vim.defer_fn(function()
  require("config.01-colors")
  require("config.04-lsp")
  require("config.05-telescope")
  require("config.06-treesitter")
  require("config.07-cmp")
  require("config.08-ui")
end, 500)