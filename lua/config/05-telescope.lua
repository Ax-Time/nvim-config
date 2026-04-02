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
