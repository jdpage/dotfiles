" disable filetype during setup
filetype off

" vundle stuff!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Bundle 'scrooloose/syntastic'
" Bundle 'vim-pandoc/vim-pandoc'
Bundle 'tpope/vim-markdown'
" Bundle 'vim-scripts/taglist.vim'
" Bundle 'nanotech/jellybeans.vim'
" Bundle 'vim-scripts/taglist.vim'
" Bundle 'Rip-Rip/clang_complete'
" Bundle 'vim-scripts/DoxygenToolkit.vim'
Bundle 'altercation/vim-colors-solarized'

" map local leader (don't remember what this does :)
let maplocalleader = ","

" go stuff! Might need to be updated
set rtp+=/usr/local/go/misc/vim

" filetype and syntaxy stuff
filetype plugin indent on
" colorscheme kyle
" colorscheme jellybeans
set background=light
let g:solarized_termcolors=16
let g:solarized_termtrans=1
colorscheme solarized
syntax on

call togglebg#map("<F5>")

"-- PORTABLE STUFF BELOW --"

set autoindent          " automatic indenting
set linebreak           " when visually wrapping, wrap sensibly
set number              " display line numbers
set textwidth=80        " auto-wrap at 80 chars
set colorcolumn=80      " show a vertical line at 80 chars
set tabstop=8           " tabs are eight characters wide
set shiftwidth=4        " indents are four characters wide
set expandtab           " expand indents into spaces
set smarttab            " shiftwidth at beginning of lines, tabstop elsewhere
set hidden              " enable hidden buffers
" set foldmethod=syntax   " fold on indentation
set showcmd             " show incomplete commands
" set mouse=a             " MOUSE MOUSE MOUSE oh hell no
set guifont=Inconsolata\ 10

" double-tab j to bail.
" inoremap jj <Esc>
" rewrap current paragraph
noremap <C-e> gwap

"-- SPECIAL SETTINGS --"

let g:clang_auto_select=1
let g:clang_complete_copen=1
let g:clang_hl_errors=1
let g:clang_periodic_quickfix=1
let g:clang_close_preview=1
let g:load_doxygen_syntax=1
