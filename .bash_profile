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

    [ -f '/etc/profile.d/rvm.sh' ] && source /etc/profile.d/rvm.sh
else
    if [ "$BASH_RC_EXECUTED" == "1" ]; then
        export BASH_RC_EXECUTED="1"
        [ -f ~/.bashrc ] && source ~/.bashrc
    fi
    source /etc/bash_completion.d/git
    alias ls="ls --color=auto"
    alias grep="grep --color=auto"
fi


# prompt
#export PS1="[\u@\h \W $(__git_ps1 '(%s)')]\\$ "
export PS1="[\u@\h \W \[$(tput setaf 2)\]$(__git_ps1 '(%s)')\[$(tput sgr0)\]] \$ ";
