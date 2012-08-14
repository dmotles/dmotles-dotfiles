set exrc
set secure

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
