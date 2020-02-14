let mapleader =","
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
autocmd FileType cpp  nnoremap <F8> :w! <CR> :sp <CR> <C-w>j :term compile %  <CR> i
nnoremap <F2> :bnext <CR> 
nnoremap <F3> :bprevious <CR> 
" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
    map <M-h> <C-w>h
	map <M-j> <C-w>j
	map <M-k> <C-w>k
	map <M-l> <C-w>l
" Shortcuts 
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy
vnoremap  <M-c>  "+y

" " Paste from clipboard
nnoremap <leader>p "+p
norema <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
map <leader>n :NERDTreeToggle<CR>
let g:clang_library_path='/usr/lib/llvm-6.0/lib'
" if hidden is not set, TextEdit might fail.
map <leader>f :Goyo <CR>
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set smarttab
set expandtab
set t_Co=16
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
autocmd BufWritePost  config.h !sudo make install
" vim airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
:set mouse=a 
