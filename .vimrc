set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" PLUGINS

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'maralla/completor.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" =============== GENERAL CONFIG (Non Plugin Specific) ======================

filetype on
filetype indent on
filetype plugin on

" autocd to cwd of current file so :e <filename> can autocomplete in cwd
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" Set my leader key
let mapleader = ','

" SPACES
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set nowrap
set textwidth=0

" syntax
syntax enable

" Enable ruler
set ruler

" Searching
set smartcase
set incsearch
set showmatch
set hlsearch

" C
au FileType c setlocal textwidth=80
au FileType c setlocal cinoptions=:0,l1,t0,(4,u0,Ws
au FileType c setlocal formatoptions=croql
au FileType c setlocal comments=sr:/*,mb:*,el:*/,://

" vim
au FileType vim setlocal textwidth=0


" ============================ vim-airline ==================================
" make it so airline shows up even with a single window
set laststatus=2
