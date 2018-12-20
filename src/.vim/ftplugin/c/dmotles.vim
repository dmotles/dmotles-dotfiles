" grep {
    if executable('ag')
        setlocal grepprg=ag\ --nogroup\ --nocolor\ --vimgrep\ --cc
        setlocal grepformat=%f:%l:%c:%m
    endif
"}
