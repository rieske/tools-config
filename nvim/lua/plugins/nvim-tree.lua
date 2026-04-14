return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<C-g>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    opts = {
      update_focused_file = { enable = true },
    },
  },
}
