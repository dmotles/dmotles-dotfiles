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

filetype on
filetype indent on
filetype plugin on

" Set my leader key
let mapleader = ','

" SPACES
set tabstop=4
set shiftwidth=4
set softtabstop=0
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

" ============================ vim-airline ==================================
" make it so airline shows up even with a single window
set laststatus=2
