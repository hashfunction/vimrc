let mapleader = ","
nnoremap ; :
nnoremap : ;
filetype plugin indent on
syntax on

set showcmd
set runtimepath^=~/.vim/bundle/ctrlp.vim

syntax enable
set grepprg=grep\ -nH\ $*

set autoindent
set expandtab
set smarttab
set smartindent
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
set undofile
set history=1000
set undolevels=1000
set updatecount=1000
set backupdir=~/.vim/backup/
set directory=~/.vim/swp/
set undodir=~/.vim/undo/

set autochdir

au BufWritePost * :Obsess ~/.session

au BufWritePost *.java  :!javac %:p && java %:r
au BufWritePost *.js :!node %:p

au FileType gitcommit set tw=68 spell
set viminfo='10,\"100,:20,%,n~/.viminfo'
map <C-J> <C-W>j<C-W>
map <C-K> <C-W>k<C-W>
map <C-L> <C-W>l<C-W>
map <C-H> <C-W>h<C-W>

nnoremap vs vsplit
nnoremap hs split

inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>


nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv>>

set tags=./tags,tags;$HOME

function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf

function CloseBracket()
 if match(getline(line('.') + 1), '\s*}') < 0
 return "\<CR>}"
 else
 return "\<Esc>j0f}a"
 endif
endf

function QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf

augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

highlight Pmenu ctermbg=238 gui=bold

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
let g:ctrlp_working_path_mode = 'ra'  " search for nearest ancestor like .git, .hg, and the directory of the current file
let g:ctrlp_match_window_bottom = 1   " show the match window at the top of the screen
let g:ctrlp_max_height = 8      " maxiumum height of match window
let g:ctrlp_switch_buffer = 'et'    " jump to a file if it's open already
let g:ctrlp_use_caching = 1       " enable caching
let g:ctrlp_clear_cache_on_exit=0     " speed up by not removing clearing cache evertime
let g:ctrlp_show_hidden = 1       " show me dotfiles
let g:ctrlp_mruf_max = 250        " number of recently opened files

let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:unite_source_history_yank_enable = 1
let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_source_rec_max_cache_files=5000
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ 'git5/.*/review/',
      \ 'google/obj/',
      \ ], '\|'))

" Use the fuzzy matcher for everything
call unite#filters#matcher_default#use(['matcher_fuzzy'])

" Use the rank sorter for everything
call unite#filters#sorter_default#use(['sorter_rank'])

nnoremap <space>/ :Unite grep:.<cr>
nnoremap <space>y :Unite history/yank<cr>
nnoremap <leader>f :Unite file_rec<cr>
nnoremap <leader>c :Unite colorscheme -auto-preview<cr>

autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
  let b:SuperTabDisabled=1
  "imap <buffer> <C-j> <NOP>
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction
