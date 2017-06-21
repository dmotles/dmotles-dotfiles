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
esac

echo "zshrc end"
