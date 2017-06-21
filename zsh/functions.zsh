#!/bin/zsh

function dotfiles() {
    local subcmd=$1
    local ret=0
    case "$subcmd" in
        update)
            pushd $DMOTLES_DOTFILES_ROOT
            git pull origin master --ff-only
            ret=$?
            popd
            ;;
        *)
            echo 'Unknown subcmd: ' $subcmd
            return 1
            ;;
    esac
}
