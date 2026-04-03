require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
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
  vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ timeout_ms = 10000 }) end, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function() vim.lsp.buf.format({ timeout_ms = 10000 }) end,
  })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('pyright', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('gopls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('clangd', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('pyright')
vim.lsp.enable('gopls')
vim.lsp.enable('clangd')

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})