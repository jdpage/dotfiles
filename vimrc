" disable filetype during setup
filetype off

" vundle stuff!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'scrooloose/syntastic'
" Bundle 'vim-pandoc/vim-pandoc'
Bundle 'vim-scripts/taglist.vim'
Bundle 'nanotech/jellybeans.vim'
Bundle 'vim-scripts/taglist.vim'

" map local leader (don't remember what this does :)
let maplocalleader = ","

" go stuff! Might need to be updated
set rtp+=/usr/local/go/misc/vim

" filetype and syntaxy stuff
filetype plugin indent on
" colorscheme kyle
colorscheme jellybeans
syntax on


"-- PORTABLE STUFF BELOW --"

set autoindent          " automatic indenting
set linebreak           " when visually wrapping, wrap sensibly
set number              " display line numbers
set textwidth=80        " auto-wrap at 80 chars
set colorcolumn=80      " show a vertical line at 80 chars
set tabstop=8           " tabs are four characters wide
set shiftwidth=4        " indents are four characters wide
set expandtab           " expand indents into spaces
set smarttab            " shiftwidth at beginning of lines, tabstop elsewhere
set hidden              " enable hidden buffers
set foldmethod=syntax   " fold on indentation
set showcmd             " show incomplete commands
" set mouse=a             " MOUSE MOUSE MOUSE oh hell no

" double-tab j to bail.
" inoremap jj <Esc>

