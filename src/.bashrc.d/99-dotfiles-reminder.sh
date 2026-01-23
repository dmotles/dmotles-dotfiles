# Dotfiles setup reminder for Coder/minimal installs
# This file is sourced by .bashrc

_dotfiles_check_full_install() {
    # Only show reminder in Coder environments
    if [ "${CODER:-}" != "true" ]; then
        return
    fi

    # Check if full install has been done by looking for markers
    # fzf and zsh are installed during full setup
    if ! command -v fzf >/dev/null 2>&1 || ! command -v zsh >/dev/null 2>&1; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  📦 Dotfiles: minimal install active (git, tmux config only)"
        echo "  Run 'dotfiles-full-install' for zsh, fzf, vim plugins, etc."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    fi
}

# Define the full install command
dotfiles-full-install() {
    if [ -n "${DMOTLES_DOTFILES_ROOT:-}" ]; then
        DOTFILES_FULL=1 "$DMOTLES_DOTFILES_ROOT/install.sh"
    else
        echo "Error: DMOTLES_DOTFILES_ROOT not set. Source ~/.dmotles-dotfiles-root first."
        return 1
    fi
}

_dotfiles_check_full_install
