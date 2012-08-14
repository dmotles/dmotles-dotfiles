# Bash completion shit
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Aliases making my life easier gurl
alias ls='ls -G'
alias git='/usr/local/bin/git'


# prompt
export PS1="[\e[0:37m\\u\e[0m@\e[0:32m\\h\e[0m \e[0;31m\\w\e[0m]\e[0;36m\$(__git_ps1 ' (%s)')\e[0m\\$ "
