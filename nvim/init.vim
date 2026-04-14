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
  "airblade/vim-gitgutter",

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
  "fatih/vim-go",
  "scrooloose/nerdtree",
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

" vim-go
let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
let g:go_auto_type_info = 1           " Automatically get signature/type info for object under cursor
let g:go_doc_popup_window = 1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_rename_command='gopls'
"au filetype go inoremap <buffer> . .<C-x><C-o>

" Persistent undo
set undofile
set undolevels=1000
set undoreload=10000

" NERDtree

" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

"Switch between different windows by their direction`
no <C-j> <C-w>j| "switching to below window
no <C-k> <C-w>k| "switching to above window
no <C-l> <C-w>l| "switching to right window
no <C-h> <C-w>h| "switching to left window

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction

nnoremap <C-g> :call ToggleNerdTree()<CR>

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

