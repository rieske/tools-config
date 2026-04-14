-- Equalize split sizes when the nvim window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})
