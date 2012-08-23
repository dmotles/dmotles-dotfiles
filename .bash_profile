# BASH_PROFILE for Daniel Motles
PATH=$PATH:~/bin

# Mac specific stuff, in case I want to use this on non-macs
if [ "$MACHTYPE" == "x86_64-apple-darwin12" ]; then
    # in general, I want colors on LS
    alias ls='ls -G'

    # Add /usr/local/sbin to path
    PATH=$PATH:/usr/local/sbin

    # lets check if BREW is installed because the following require it
    if command -v brew &>/dev/null; then
        # Bash completion shit
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi

        # Aliases making my life easier gurl
        [ -f `brew --prefix`/bin/git ] && alias git="`brew --prefix`/bin/git"
        [ -f `brew --prefix`/bin/ctags ] && alias ctags="`brew --prefix`/bin/ctags"
    else
        echo "Warning: You appear to be on a Mac without homebrew installed. INSTALL IT."
    fi
fi


# prompt
export PS1="[\e[0:37m\\u\e[0m@\e[0:32m\\h\e[0m \e[0;31m\\w\e[0m]\e[0;36m\$(__git_ps1 ' (%s)')\e[0m\\$ "
