" vim: set ft=vim tw=80
"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"  FIGLET: vimrc
"

set background=dark

" Certain PYTHONPATHs can break the built-in vim python runtime.
" let $PYTHONPATH=''

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" VUNDLE
set nocompatible
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" solarized colors
Plugin 'altercation/vim-colors-solarized'

" tmux+vim integration
Plugin 'christoomey/vim-tmux-navigator'

" autocomplete
Plugin 'maralla/completor.vim'

" mercurial in-editor diff
Plugin 'ludovicchabant/vim-lawrencium'

" Make cmd that works with tmux
Plugin 'tpope/vim-dispatch'

" async building
Plugin 'neomake/neomake'

" Git/Hg +/- in the gutter
Plugin 'mhinz/vim-signify'

" Rust support
Plugin 'rust-lang/rust.vim'

" rg (ripgrep) plugin for RG command
" Plugin 'jremmen/vim-ripgrep'
Plugin 'lamchau/vim-ripgrep' " patch-1 branch because original maintainer flaked

" Javascript and JSX support
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" Better python syntax highlighting
Plugin 'vim-python/python-syntax'

" Better python indentation
Plugin 'vim-scripts/indentpython.vim'

" Tagbar - for tags
Plugin 'majutsushi/tagbar'

" ctrlp - fuzzy finder
Plugin 'ctrlpvim/ctrlp.vim'

" Terraform HCL support
Plugin 'hashivim/vim-terraform'

" Ansible support
Plugin 'pearofducks/ansible-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" VUNDLE

" General {
    syntax on                   " Syntax highlighting
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    set shortmess=aoOtT                 " shorten messages to prevent "Hit Enter" messages
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
    " }

    set autoread                        " read a file when it has been changed
    set path+=./**                      " add all files in cwd to path

    if executable('ag')
        set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
        set grepformat=%f:%l:%c:%m
    endif

    " I don't CPP right now - I C
    augroup disablecpp
        autocmd!
        autocmd BufRead,BufNewFile *.h,*.c set filetype=c
    augroup END
" }


" Vim UI {
    " colorscheme {
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        colorscheme solarized
    " }

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current

    set colorcolumn=80              " show where column 80 resides
" }

" Formatting {

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }
    autocmd FileType c,python,vim,yaml,javascript,jsx,javascript.jsx
        \ autocmd BufWritePre <buffer> call StripTrailingWhitespace()

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
" }

" Mapping {
    let mapleader = '/'
    let maplocalleader = '|'

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Break arrow key habit
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>
" }

" Completor {
    let g:completor_filesize_limit = 20480  " complete up to 20k in size
    let g:completor_blacklist = [
        \'tagbar', 'qf', 'netrw', 'unite', 'vimwiki',
        \'gitcommit', 'hgcommit', 'nerdtree'] " types to avoid

    " cycle thru with tab
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

    " cycle back without tab
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " select with enter
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" }

" Signify {
    let g:signify_vcs_list = [ 'git', 'hg' ] " only git and hg
" }

" ctrl-p {
    if executable('rg')
        let g:ctrlp_user_command = 'rg --files %s'
    elseif executable('ag')
        let g:ctrlp_user_command = 'ag -g %s'
    endif
" }

" ansible-vim {
    augroup ansible_vim_ft_detection
        au!
        au BufNewFile,BufRead */playbook/*.yml set ft=yaml.ansible
    augroup END
    let g:ansible_name_highlight = 'b'
    let g:ansible_extra_keywords_highlight = 1
    let g:ansible_template_syntaxes = {'*.bash.j2': 'sh'}
" }

" Functions {
    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Auto read when a file has changed {
    set autoread
    augroup checktime
        au!
        if !has("gui_running")
            "silent! necessary otherwise throws errors when using command
            "line window.
            autocmd BufEnter        * silent! checktime
            autocmd CursorHold      * silent! checktime
            autocmd CursorHoldI     * silent! checktime
            "these two _may_ slow things down. Remove if they do.
            "autocmd CursorMoved     * silent! checktime
            "autocmd CursorMovedI    * silent! checktime
        endif
    augroup END
    " }
"}

" vim-ripgrep {
    nnoremap <silent> <Leader>* :Rg<CR>
" }


set exrc
set secure
