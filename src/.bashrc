# ~/.bashrc - managed by dmotles-dotfiles

# Source dotfiles root if available
[ -f ~/.dmotles-dotfiles-root ] && source ~/.dmotles-dotfiles-root

# Source all files in .bashrc.d
if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*.sh; do
        [ -r "$f" ] && source "$f"
    done
    unset f
fi

# fzf keybindings if available
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
