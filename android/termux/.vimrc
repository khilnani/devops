" Windows
"------------------------
" :split
" :vsplit
" <C-W>n new
" <C-W>s split
" <C-W>v vsplit
" <C-W>c close
" <C-W>o others
map <C-w>] <C-w>w
map <C-w>[ <C-w>p

" Tabs
" -------------------------
" :tabnew
" :tabedit NAME
" :tabn
" :tabp
" :tabc
" :tabo (others)
map <C-t>] :tabn<CR>
map <C-t>[ :tabp<CR>
map <C-t>n :tabnew<CR>
map <C-t>c :tabc<CR>
map <C-t>o :tabo<CR>

" Shell
"----------------------------
" :! COMMAND
" :! bash - exit to leave
" C-z  - shell
" fg  - return

" Shell
" "--------------------------
" :sh - enter
" C-d - return

"----------------------------------------------
" indentation 

filetype indent on    " turn on indenting
set shiftwidth=4
set autoindent    " auto indent. note - causes issues when pasting text with indents
set smarttab
set smartindent
set tabstop=4
set expandtab
set nowrap    " do not wrap
set linebreak   " wraplines at convinient points


"----------------------------------------------
" turn of swap files

set noswapfile
set nobackup
set nowb


"---------------------------------------------
" scrolling
" 
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1


"----------------------------------------------
" code folding
" zo - opens all fold
" zO - opens single fold
" zc - closes
" zm - reduces level of fold by one
" zM - closes all open folds
" [z - move to start of open fold
" ]z - move to end of open fold

set foldmethod=indent   "fold based on indent, syntax
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable          "set nofoldenable
set foldlevel=10


"----------------------------------------------
" display

set ruler   " display the cursor at all times
set cursorline
set number    " display line numbers. note - selecting text will include the line numbers
set ignorecase    " ignore case when searching
"set list listchars=tab:··,trail:·,eol:^   " display tabs and trailing space$
set list listchars=tab:··,trail:·   " display tabs and trailing space$
set visualbell    " no audio
set showcmd   " show incomplete commands in status bar
set showmode    "show mode at the bottom
set noautoread    " do not auto load files if mofieid outside

" Cursor customization
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

"----------------------------------------------
" color schemes

syntax on
set background=dark
"colorscheme solarized
colorscheme jellybeans

"----------------------------------------------
" code completion

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"----------------------------------------------
" Terminal in a window setup
" See https://code.google.com/p/conque

let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_Color = 1
let g:ConqueTerm_EscKey = '<Esc>'

:cabbrev sh ConqueTermSplit bash

let g:vim_markdown_folding_disabled=1

"----------------------------------------------
" filetype specific behaviors

filetype plugin on

autocmd BufNewFile,BufRead *.json set ft=javascript

autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby compiler ruby
autocmd FileType ruby map <C-r> :! ruby %<CR>

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python map <C-r> :! python %<CR>

autocmd FileType sh map <C-r> :! sh %<CR>

autocmd FileType php map <C-r> :! php %<CR>

autocmd FileType scala map <C-r> :! scala %<CR>

nmap <buffer> time :call nik#time()<CR>
nmap <F2> :echo 'Current time is ' . strftime('%c')<CR>

map <S-k> gT
map <S-l> gt
map <S-t> :tabnew<CR>
map <S-s> :ConqueTermSplit bash<CR>

"----------------------------------------------
" on Vim Load. see :h startup and :h VimEnter

" autocmd VimEnter * ConqueTermSplit bash
" autocmd VimEnter * resize 20


" au BufNewFile *.py r ~/.vim/templates/script.py


