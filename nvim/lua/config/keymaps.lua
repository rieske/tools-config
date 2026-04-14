local map = vim.keymap.set

map("n", "<C-N>", "<cmd>nohlsearch<cr>", { silent = true })
map("n", "<F12>", "<cmd>nohlsearch<cr>")

map("i", "<Nul>", "<C-x><C-o>")

map("", "<Space>", "<C-f>")
map("", "<BS>", "<C-b>")

map("", "-", "<C-w>w")
map("", "_", [[<C-\>]])

map("", "<C-j>", "<C-w>j")
map("", "<C-k>", "<C-w>k")
map("", "<C-l>", "<C-w>l")
map("", "<C-h>", "<C-w>h")

map("n", "B", "^")
map("n", "E", "$")
