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
call plug#end()
autocmd FileType cpp  nnoremap <F8> :w <CR> :vsp <CR> <C-w>l :term g++ % -o %< <CR> ./%< <CR> i
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
