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

-- Check if first run (plugins not installed yet)
local plugins_dir = vim.fn.stdpath("data") .. "/lazy"
local lock_file = plugins_dir .. "/.lock"
local needs_sync = false

if vim.uv.fs_stat(lock_file) == nil then
  -- First run or new plugins - sync now
  needs_sync = true
end

-- Load configs that require plugins
require("config.00-init")
require("config.01-colors")
require("config.02-keymaps")
require("config.04-lsp")
require("config.05-telescope")
require("config.06-treesitter")
require("config.07-cmp")
require("config.08-ui")

-- Sync if needed (blocking on first run)
if needs_sync then
  vim.cmd("Lazy! sync")
  -- Create lock file
  vim.fn.writefile({}, lock_file)
end