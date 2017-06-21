echo "zshrc start"
OS=$(uname -s)

source ~/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme bureau
antigen apply

echo "zshrc end"
