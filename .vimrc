let mapleader = ","
nnoremap ; :
nnoremap : ;
filetype plugin indent on
syntax on

set showcmd

syntax enable
set grepprg=grep\ -nH\ $*

set autoindent

set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" set wildmenu
" set wildmode=list:longest,full

set number

set ignorecase
set smartcase

inoremap jj <Esc>

nnoremap JJJJ <Nop>

set incsearch

set hlsearch

let g:clipbrdDefaultReg = '+'

set backup
set history=200
set undolevels=1000
set updatecount=100
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

set autochdir

nnoremap <leader>r :!node %:p
