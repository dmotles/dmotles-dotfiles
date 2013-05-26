[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# GPG Agent stuff
if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
    GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
    SSH_AUTH_SOCK=`cat $HOME/.ssh-auth-sock`
    SSH_AGENT_PID=`cat $HOME/.ssh-agent-pid`
    export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
else
    eval `gpg-agent --daemon`
    echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
    echo $SSH_AUTH_SOCK > $HOME/.ssh-auth-sock
    echo $SSH_AGENT_PID > $HOME/.ssh-agent-pid
fi
# Imperative that this environment variable always reflects the output
# of the tty command.
GPG_TTY=`tty`
export GPG_TTY

echo "zprofile executed"
