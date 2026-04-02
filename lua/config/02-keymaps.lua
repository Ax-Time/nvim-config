local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>n", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>p", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open explorer" })

map("n", "<leader>tv", "<cmd>vsplit<bar>terminal<cr>", { desc = "Terminal vertical" })
map("t", "<esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

map("n", "<c-h>", "<c-w>h", { desc = "Window left" })
map("n", "<c-j>", "<c-w>j", { desc = "Window down" })
map("n", "<c-k>", "<c-w>k", { desc = "Window up" })
map("n", "<c-l>", "<c-w>l", { desc = "Window right" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
