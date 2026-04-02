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