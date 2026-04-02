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
