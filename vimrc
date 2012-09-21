" hax
filetype off

let maplocalleader = ","

set rtp+=/usr/local/go/misc/vim

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'nanotech/jellybeans.vim'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-afterimage'
Bundle 'scrooloose/syntastic'
" Bundle 'plasticboy/vim-markdown'
" Bundle 'tpope/vim-markdown'
Bundle 'vim-pandoc/vim-pandoc'
Bundle 'myusuf3/numbers.vim'

set autoindent
filetype plugin indent on

set background=dark
colorscheme jellybeans
syntax on

set number

map k gk
map j gj
map E ge
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

set wrap
set linebreak

set colorcolumn=80
set tabstop=4 shiftwidth=4 expandtab smarttab

let g:lisp_rainbow=1
let g:syntastic_auto_log_list=1
set guifont=MonteCarlo\ Regular:h11
" set guifont=Envy\ Code\ R:h11

" enable hidden buffers
set hidden
