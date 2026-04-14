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

  { "junegunn/fzf", build = ":call fzf#install()" },
  "junegunn/fzf.vim",

  "vim-airline/vim-airline",
  "mmozuras/vim-whitespace",
  "fatih/vim-go",
  "scrooloose/nerdtree",
  "vim-scripts/a.vim",

  "prabirshrestha/async.vim",
  "prabirshrestha/vim-lsp",
  "mattn/vim-lsp-settings",

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
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

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

" ctrl-p opens fzf
nnoremap <C-p> :<C-u>FZF<CR>
"## Solarized Light color scheme for fzf
"#export FZF_DEFAULT_OPTS="
"#  --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
"#  --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
"#"
let g:fzf_colors =
    \ { 'fg': ['fg', 'Black'],
    \ 'bg': ['bg', 'Black']}

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
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> <f7> <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <f8> <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <f6> <plug>(lsp-rename)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <f1> <plug>(lsp-document-diagnostics)
    nmap <buffer> <f2> <plug>(lsp-code-action)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    " refer to doc to add more commands
endfunction

let g:lsp_highlight_references_enabled = 1
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')

let g:lsp_settings = {
            \    'clangd': {'cmd': ['clangd', '-cross-file-rename']}
\}

