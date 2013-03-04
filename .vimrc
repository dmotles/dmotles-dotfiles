set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'AutoComplPop'
Bundle 'snipMate'

" NON BUNDLED
Bundle 'scrooloose/syntastic'
Bundle 'https://github.com/StanAngeloff/php.vim'
Bundle 'https://github.com/vexxor/phpdoc.vim'
Bundle 'https://github.com/wincent/Command-T'
Bundle 'git://github.com/majutsushi/tagbar'
Bundle 'https://github.com/techlivezheng/tagbar-phpctags'
Bundle 'shawncplus/phpcomplete.vim'


if has("autocmd")
    " turn on file-type specific stuff
    filetype on
    filetype indent on
    filetype plugin on

    " turn on auto-completion
    if exists("+omnifunc")
        autocmd Filetype *
            \   if &omnifunc == "" |
            \       setlocal omnifunc=syntaxcomplete#Complete |
            \   endif

        " select longest completion by default, and display even if there's
        " only 1 menu item
        set completeopt=longest,menuone

        " make it so <Enter> selects a completion
        inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    endif
endif

" generic editor preferences
syntax on
set number
set expandtab
set autoindent
set tabstop=2
set shiftwidth=2
set tags=./tags;/
set ruler
set comments=sl:/**,mb:*,elx:*/
set formatoptions+=r
set showmode
set textwidth=79
set wrapmargin=5

" show the `best match so far' as search strings are typed:
set incsearch

" Set my leader key

let mapleader = ','

" Tag list commands

" Tagbar commands
nnoremap <silent> <Leader>l :TagbarToggle<CR>



" Nerdtree commands

"let g:NERDTreeQuitOnOpen = 1
"nmap <silent> <leader>nt <Esc>:NERDTreeToggle<CR>
"nmap <silent> <leader>\ <Esc>:NERDTreeToggle<CR>
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"phpdoc command
nnoremap <silent> <leader>p <Esc>:call PhpDoc()<CR>
"
"set bg=dark

"JFLEX syntax support (YAY)
augroup filetype
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim


"cup syntax highlighting
autocmd BufNewFile,BufRead *.cup setf cup

" php-specific settings
au Filetype php setlocal comments=sl:/**,mb:*,elx:*/
au Filetype php setlocal ofu=phpcomplete#CompletePHP

" modify the external program used for grep
" -n print line
" -w match only words
" -R recursive search
" -H filename
" $* args from vim
" /dev/null - incase user passes nothing
set grepprg=grep\ -nRH\ '--exclude-dir=*.svn*'\ --exclude=tags\ '--include=*.xml'\ '--include=*.php'\ $*\ /dev/null

" bind a key to searching
" <silent> - don't echo command in command line
" <cword> current word cursor is on
" <Bar> vertical bar character
" cw open current change list (close with :ccl)
nnoremap <silent> <C-G> :execute 'grep! ' . expand('<cword>') . ' *' <Bar> cw<CR> 
nnoremap <silent> <C-H> :execute 'lgrep! ' . expand('<cword>') . ' *' <Bar> lopen<CR> 
