return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "gopls", "rust_analyzer", "lua_ls" },
        automatic_enable = false,
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "-cross-file-rename" },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.enable({ "clangd", "gopls", "rust_analyzer", "lua_ls" })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, opts) end

          map("gd", vim.lsp.buf.definition)
          map("gs", vim.lsp.buf.document_symbol)
          map("gS", vim.lsp.buf.workspace_symbol)
          map("gr", vim.lsp.buf.references)
          map("<F7>", vim.lsp.buf.references)
          map("gi", vim.lsp.buf.implementation)
          map("<F8>", vim.lsp.buf.implementation)
          map("gt", vim.lsp.buf.type_definition)
          map("<F6>", vim.lsp.buf.rename)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<F1>", vim.diagnostic.setloclist)
          map("<F2>", vim.lsp.buf.code_action)
          map("[g", function() vim.diagnostic.jump({ count = -1, float = true }) end)
          map("]g", function() vim.diagnostic.jump({ count = 1, float = true }) end)
          map("K", vim.lsp.buf.hover)
        end,
      })

      -- Go: format + organize imports on save (via gopls).
      -- Sync code-action ordering matters: imports must apply before format runs.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local clients = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })
          if #clients == 0 then return end
          local encoding = clients[1].offset_encoding or "utf-16"

          local params = vim.lsp.util.make_range_params(0, encoding)
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then vim.lsp.util.apply_workspace_edit(r.edit, encoding) end
            end
          end
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
  { "mfussenegger/nvim-jdtls", ft = "java" },
}
