" hax
filetype off

set rtp+=$GOROOT/misc/vim

call pathogen#runtime_append_all_bundles()

set autoindent
filetype plugin indent on
set ofu=syntaxcomplete#Complete
set completeopt=longest,menuone

function! SuperCleverTab()
	if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
		return "\<Tab>"
	else
		if &omnifunc != ''
			return "\<C-X>\<C-O>"
		elseif &dictionary != ''
			return "\<C-K>"
		else
			return "\<C-N>"
		endif
	endif
endfunction

autocmd FileType tex source ~/.vim/tex.vim

" au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod +x <afile> | endif | endif
autocmd BufWritePost *.coffee silent CoffeeMake!

set background=dark
colorscheme jdpage_black
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

set cc=80
set ts=4 sw=4 expandtab

let g:lisp_rainbow=1
