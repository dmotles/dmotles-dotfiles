echo "zshrc start"

export PATH="~/bin:$PATH"

source ~/.dmotles-dotfiles-root
source ~/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme bureau
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
        ;;
esac


function dotfiles() {
    local subcmd=$1
    shift

    case "$subcmd" in
        st|status|diff|add|commit|push|pull)
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
                && source ~/.zshrc \
                && antigen reset
            ;;
        *)
            cat <<EOF
dotfiles [subcmd] [args]

Available subcommands:

    status  get the git status
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


echo "zshrc end"
