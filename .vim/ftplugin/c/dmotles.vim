" grep {
    if executable('ag')
        set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep\ --cc
        set grepformat=%f:%l:%c:%m
    endif
"}
