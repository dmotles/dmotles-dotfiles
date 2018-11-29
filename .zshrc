echo "zshrc start"

export PATH="~/bin:$PATH"

source ~/.dmotles-dotfiles-root
source ~/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle thewtex/tmux-mem-cpu-load

if [ -f ~/.antigen.theme ]; then
    antigen theme $(<~/.antigen.theme)
else
    antigen theme bureau
fi

antigen apply

setopt histignorealldups sharehistory
bindkey -e
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

case $(uname -s) in
    Darwin)
        ;;
    Linux)
        alias ls='/bin/ls --color=auto'
        alias tmux='/usr/bin/tmux -2'
        ;;
esac


function dotfiles() {
    local subcmd=$1
    shift

    case "$subcmd" in
        st|status|diff|add|commit|push|pull|show)
            git --git-dir=$DMOTLES_DOTFILES_ROOT/.git --work-tree=$DMOTLES_DOTFILES_ROOT $subcmd $@
            ;;
        install)
            $DMOTLES_DOTFILES_ROOT/install.sh
            if which antigen &>/dev/null; then
                antigen reset
            fi
            ;;
        update)
            git --git-dir=$DMOTLES_DOTFILES_ROOT/.git --work-tree=$DMOTLES_DOTFILES_ROOT pull \
                && $DMOTLES_DOTFILES_ROOT/install.sh \
                && source ~/.zshrc
                if which antigen &>/dev/null; then
                    antigen reset
                fi
            ;;
        *)
            cat <<EOF
dotfiles [subcmd] [args]

Available subcommands:

    status  get the git status
    show    do git show
    diff    get the git diff
    add     add changes
    commit  commit changes
    push    push changes
    pull    pull changes
    update  pull, run install, source zshrc
EOF
            ;;
    esac
}

function rmrej() {
    find . \( -name '*.orig' -o -name '*.rej' \) -print -delete
}

SSH_AGENT_ENV=~/.ssh/agent-env
function -try-load-ssh-agent-env() {
    if [ -f ${SSH_AGENT_ENV} ]; then
        . ${SSH_AGENT_ENV}
    fi
}

function -new-ssh-agent() {
    ssh-agent -s > ${SSH_AGENT_ENV}
    . ${SSH_AGENT_ENV}
}

function -ssh-agent-up() {
    if [ -n "${SSH_AUTH_SOCK+1}" ]; then
        ssh-add -L &>/dev/null
        local ssh_add_exit_code=$?
        local ssh_add_output=`ssh-add -L 2>&1`
        if [[ $ssh_add_exit_code == 1 ]]; then
            if [[ "$ssh_add_output" == 'The agent has no identities.' ]]; then
                return 0
            fi
        fi
        return $ssh_add_exit_code
    fi
    return 1
}

function refresh-ssh-agent() {
    # try load latest ssh-agent
    -try-load-ssh-agent-env

    if ! -ssh-agent-up; then
        -new-ssh-agent
    fi
}

refresh-ssh-agent

if [ -f ~/.zshrc-work ]; then
    . ~/.zshrc-work
fi

echo "zshrc end"
