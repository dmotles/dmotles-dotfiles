echo "zshrc start"

case $(uname -s) in
    Darwin)
        export HOMEBREW_PREFIX="/opt/homebrew";
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
        export HOMEBREW_REPOSITORY="/opt/homebrew";
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
        export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
        export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
        ;;
    Linux)
        alias ls='/bin/ls --color=auto'
        alias tmux='/usr/bin/tmux -2'
        ;;
esac

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit && compinit
autoload -Uz bashcompinit
bashcompinit -i

[ -f /usr/local/bin/aws_zsh_completer.sh ] && source /usr/local/bin/aws_zsh_completer.sh
typeset -U path
path+=("$HOME/bin")

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

function dotfiles() {
    local subcmd=$1
    shift

    case "$subcmd" in
        git)
            git --git-dir=$DMOTLES_DOTFILES_ROOT/.git --work-tree=$DMOTLES_DOTFILES_ROOT $@
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

    git     do a git operation in the dotfiles dir.
    install run the install script. Might be safe to do.
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "zshrc end"
