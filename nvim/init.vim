lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "Tsuzat/NeoSolarized.nvim",

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cpp", "diff", "dockerfile", "git_config", "gitcommit",
          "go", "gomod", "gosum", "gowork", "java", "json", "kotlin", "ledger",
          "lua", "make", "markdown", "markdown_inline", "python", "rust",
          "toml", "vim", "vimdoc", "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = { fzf = {} },
      })
      telescope.load_extension("fzf")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
      options = { theme = "auto", globalstatus = true },
        tabline = {
          lualine_a = { "buffers" },
          lualine_z = { "tabs" },
        },
      })
    end,
  },
  "mmozuras/vim-whitespace",
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        update_focused_file = { enable = true },
      })
      vim.keymap.set("n", "<C-g>", "<cmd>NvimTreeToggle<CR>", { silent = true })
    end,
  },
  "vim-scripts/a.vim",

  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  { "mfussenegger/nvim-jdtls", ft = "java" },

  "udalov/kotlin-vim",
  "hashivim/vim-vagrant",

  "rust-lang/rust.vim",

  "ledger/vim-ledger",
  "github/copilot.vim",
})
EOF

set termguicolors
set background=light
colorscheme NeoSolarized

set encoding=utf-8

" vim-ledger
let g:ledger_is_hledger=v:false


set updatetime=100

set noswapfile
set showmode
set showcmd
set ignorecase
set smartcase
set showbreak=...
set wrap linebreak nolist
set linespace=4
set showmatch
set number
set laststatus=2

set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.obj,*.class,*.so,*.gcda,*.gcov,*.gcno,*.lo,*.la,*.out

set hlsearch
set incsearch
set visualbell
set exrc
nmap <silent> <C-N> :silent noh<CR>

set autoread
set ruler

inoremap <Nul> <C-x><C-o>

autocmd VimResized * :wincmd =

filetype plugin indent on
syntax on

set shiftwidth=4
set tabstop=4
set expandtab
set autoindent

set backspace=indent,eol,start

" these two maps enable you to press space to move cursor down a screen,
" and press backspace up a screen.
map <space> <c-f>
map <backspace> <c-b>

" use - to jump between windows
map - <c-w>w
map _ <c-\>

set complete=.,w,b,u,t,i
set completeopt=menu,popup

set tags+=~/.system.tags

nnoremap <f12> :noh<cr>
nnoremap B ^
nnoremap E $

set smarttab

" Telescope
nnoremap <C-p> <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fs <cmd>Telescope lsp_document_symbols<CR>

let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1

" Go: format + organize imports on save (via gopls)
lua << EOF
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then vim.lsp.util.apply_workspace_edit(r.edit, "utf-16") end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})
EOF

" Persistent undo
set undofile
set undolevels=1000
set undoreload=10000

"Switch between different windows by their direction`
no <C-j> <C-w>j| "switching to below window
no <C-k> <C-w>k| "switching to above window
no <C-l> <C-w>l| "switching to right window
no <C-h> <C-w>h| "switching to left window

" LSP
lua << EOF
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

    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.wo.signcolumn = "yes"

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
    map("[g", vim.diagnostic.goto_prev)
    map("]g", vim.diagnostic.goto_next)
    map("K", vim.lsp.buf.hover)
  end,
})
EOF

