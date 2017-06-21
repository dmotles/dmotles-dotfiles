echo "zshrc start"
OS=$(uname -s)

case $OS in
    Darwin)
        source ~/antigen/antigen.zsh

        antigen use oh-my-zsh
        antigen bundle zsh-users/zsh-syntax-highlighting
        antigen theme bureau
        antigen apply
        ;;
    Linux)
        autoload -Uz compinit promptinit
        compinit
        promptinit
        prompt walters
        setopt histignorealldups sharehistory
        bindkey -e
        HISTSIZE=1000
        SAVEHIST=1000
        HISTFILE=~/.zsh_history
esac

echo "zshrc end"
