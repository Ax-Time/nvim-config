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
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "lua_ls", "tsserver", "rust_analyzer", "pyright", "gopls", "clangd" }
for _, server in ipairs(servers) do
  require("lspconfig")[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})
