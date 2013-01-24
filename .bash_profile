# BASH_PROFILE for Daniel Motles
PATH=~/bin:$PATH

# Windows - CygWin (I KNOW WHO USES CYGGWIN LUL?)
if [ $OS == "Windows_NT" ]; then
    shopt -s histappend
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
    alias grep='grep --color'                     # show differences in colour
    alias egrep='egrep --color=auto'              # show differences in colour
    alias fgrep='fgrep --color=auto'              # show differences in colour
    #
    # Some shortcuts for different directory listings
    alias ls='ls -hF --color=tty'                 # classify files in colour
    alias dir='ls --color=auto --format=vertical'
    # alias vdir='ls --color=auto --format=long'
    alias ll='ls -l'                              # long list
    # alias la='ls -A'                              # all but . and ..
    # alias l='ls -CF'                              #
    export PATH="$PATH:/cygdrive/c/Program Files/Java/jdk1.7.0_04/bin"
    export PATH="$PATH:/cygdrive/c/Program Files (x86)/Android/android-sdk/platform-tools"
    export PATH="$PATH:/usr/local/linaro/bin"
    if [ -f "/etc/bash_completion.d/git" ]; then
      . /etc/bash_completion.d/git
    fi
    if [ -f "/etc/bash_completion.d/password-store" ]; then
        . /etc/bash_completion.d/password-store
    fi

# Mac specific stuff, in case I want to use this on non-macs
elif [ "$MACHTYPE" == "x86_64-apple-darwin12" ]; then
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
fi


# prompt
export PS1="[\[\033[0:37m\]\\u\[\033[0m\]@\[\033[0:32m\]\\h\[\033[0m\] \[\033[0;31m\]\\w\[\033[0m\]]\[\033[0;36m\]\$(__git_ps1 ' (%s)')\[\033[0m\]\\$ "
