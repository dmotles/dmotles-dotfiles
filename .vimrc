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
set tabstop=2
set shiftwidth=2
set tags=./tags;/
set ruler
set comments=sl:/**,mb:*,elx:*/
set formatoptions+=r
set showmode

" show the `best match so far' as search strings are typed:
set incsearch

" Set my leader key

let mapleader = ','

" Tag list commands

"nnoremap <silent> <Leader>l :TlistToggle<CR>
"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
"let Tlist_Auto_Open = 1
"let Tlist_Exit_OnlyWindow = 1
"let Tlist_Use_Right_Window = 1
"let Tlist_Process_File_Always = 1
"let Tlist_Auto_Highlight_Tag = 1
"let Tlist_Display_Prototype = 0
"let Tlist_Display_Tag_Scope = 1
"let Tlist_GainFocus_On_ToggleOpen = 1
"let Tlist_Show_One_File = 1
"let Tlist_Sort_Type = "name"
"let Tlist_Max_Submenu_Items = 20
"

" Tagbar commands
nnoremap <silent> <Leader>l :TagbarToggle<CR>



" Nerdtree commands

let g:NERDTreeQuitOnOpen = 1
nmap <silent> <leader>nt <Esc>:NERDTreeToggle<CR>
nmap <silent> <leader>\ <Esc>:NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"phpdoc command
nnoremap <silent> <leader>p <Esc>:call PhpDoc()<CR>

set bg=dark

"JFLEX syntax support (YAY)
augroup filetype
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

"autotag
so ~/vimplugins/autotag/plugin/autotag.vim

"cup syntax highlighting
autocmd BufNewFile,BufRead *.cup setf cup
