# Dotfiles bootstrap status and manual retry command.

_dotfiles_check_bootstrap() {
    if [ "${CODER:-}" != "true" ] || [ ! -t 1 ]; then
        return
    fi

    state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dmotles-dotfiles"
    if [ ! -f "$state_dir/bootstrap.complete" ]; then
        echo ""
        echo "Dotfiles user tools are still installing or need a retry."
        echo "Run 'dotfiles-full-install' to retry; log: $state_dir/bootstrap.log"
        echo ""
    fi
}

dotfiles-full-install() {
    if [ -n "${DMOTLES_DOTFILES_ROOT:-}" ]; then
        "$DMOTLES_DOTFILES_ROOT/install.sh" --force-bootstrap
    else
        echo "Error: DMOTLES_DOTFILES_ROOT not set. Source ~/.dmotles-dotfiles-root first."
        return 1
    fi
}

_dotfiles_check_bootstrap
unset -f _dotfiles_check_bootstrap
