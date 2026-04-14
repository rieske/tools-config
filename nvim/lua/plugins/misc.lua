return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Glog", "Gclog", "GBrowse", "GMove", "GDelete", "GRename" },
  },
  {
    "mmozuras/vim-whitespace",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "vim-scripts/a.vim",
    cmd = { "A", "AS", "AV", "AT", "AN", "IH", "IHS", "IHV", "IHT" },
  },
  {
    "ledger/vim-ledger",
    ft = "ledger",
    init = function()
      vim.g.ledger_is_hledger = false
    end,
  },
}
