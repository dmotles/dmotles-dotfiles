" grep {
    if executable('ag')
        setlocal grepprg=ag\ --nogroup\ --nocolor\ --vimgrep\ --python
        setlocal grepformat=%f:%l:%c:%m
    endif
"}
