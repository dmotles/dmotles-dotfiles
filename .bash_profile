# BASH_PROFILE for Daniel Motles
PATH=~/bin:$PATH

# Mac specific stuff, in case I want to use this on non-macs
if [ "$MACHTYPE" == "x86_64-apple-darwin12" ]; then
    # in general, I want colors on LS
    alias ls='ls -G'

    # Add /usr/local/sbin to path
    PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin
    PATH=~/bin:$PATH

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
else
    source ~/.bashrc
    source /etc/bash_completion.d/git
    alias ls="ls --color=auto"
    alias grep="grep --color=auto"
fi


# prompt
export PS1="[\[\033[0:37m\]\\u\[\033[0m\]@\[\033[0:32m\]\\h\[\033[0m\] \[\033[0;31m\]\\w\[\033[0m\]]\[\033[0;36m\]\$(__git_ps1 ' (%s)')\[\033[0m\]\\$ "
