return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "diff", "dockerfile", "git_config", "gitcommit",
        "go", "gomod", "gosum", "gowork", "java", "json", "kotlin", "ledger",
        "lua", "make", "markdown", "markdown_inline", "python", "rust",
        "toml", "vim", "vimdoc", "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
