return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      local parsers = {
        "bash", "c", "cpp", "diff", "dockerfile", "git_config", "gitcommit",
        "go", "gomod", "gosum", "gowork", "java", "json", "kotlin", "ledger",
        "lua", "make", "markdown", "markdown_inline", "python", "rust",
        "toml", "vim", "vimdoc", "yaml",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if lang and pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
