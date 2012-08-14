# Bash completion shit
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Aliases making my life easier gurl
alias ls='ls -G'
alias git='/usr/local/bin/git'
