" Pathogen lets us load plugins from a non-standard directory
call pathogen#infect('~/vimplugins')

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
set tabstop=4
set shiftwidth=4
set tags=./tags;/
set ruler
set comments=sl:/**,mb:*,elx:*/
set formatoptions+=r

" Set my leader key

let mapleader = ','

" Tag list commands

nnoremap <silent> <Leader>l :TlistToggle<CR>
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Process_File_Always = 1

" Nerdtree commands

let g:NERDTreeQuitOnOpen = 1
nmap <silent> <leader>nt <Esc>:NERDTreeToggle<CR>
nmap <silent> <leader>\ <Esc>:NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"phpdoc command
nnoremap <silent> <leader>p <Esc>:call PhpDoc()<CR>
