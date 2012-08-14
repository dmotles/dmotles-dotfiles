set exrc
set secure

" Pathogen lets us load plugins from a non-standard directory
call pathogen#infect('~/vimplugins')

if has("autocmd")
    filetype on
    filetype indent on
    filetype plugin on
endif
syntax on
set number
set expandtab
set autoindent
set tabstop=4
set shiftwidth=4

" Tag list commands

let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1
