# ~/.bashrc - managed by dmotles-dotfiles

# Source dotfiles root if available
[ -f "$HOME/.dmotles-dotfiles-root" ] && source "$HOME/.dmotles-dotfiles-root"

# Source all files in .bashrc.d
if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*.sh; do
        [ -r "$f" ] && source "$f"
    done
    unset f
fi

# fzf keybindings if available
if [ -f "$HOME/.fzf.bash" ]; then
    source "$HOME/.fzf.bash"
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
