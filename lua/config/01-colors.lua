require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  terminal_colors = true,
  dim_inactive = {
    enabled = false,
  },

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
