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
"nnoremap <silent> <Leader>l :TagbarToggle<CR>



" Nerdtree commands

"let g:NERDTreeQuitOnOpen = 1
"nmap <silent> <leader>nt <Esc>:NERDTreeToggle<CR>
"nmap <silent> <leader>\ <Esc>:NERDTreeToggle<CR>
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"phpdoc command
"nnoremap <silent> <leader>p <Esc>:call PhpDoc()<CR>
"
"set bg=dark

"JFLEX syntax support (YAY)
augroup filetype
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim


"cup syntax highlighting
autocmd BufNewFile,BufRead *.cup setf cup
