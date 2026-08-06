#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dmotles-dotfiles"
MARKER="$STATE_DIR/bootstrap.complete"
ERROR_FILE="$STATE_DIR/bootstrap.last-error"
LOG_FILE="$STATE_DIR/bootstrap.log"
LOCK_DIR="${TMPDIR:-/tmp}/dmotles-dotfiles-${UID}.lock"
ANTIGEN_REV="7c70f82cc2072ea6039a403f13ebe7085bfc316b"
VUNDLE_REV="5548a1a937d4e72606520c7484cd384e6c76b565"
FORCE=false

if [ "${1:-}" = "--force" ]; then
    FORCE=true
    shift
fi
if [ "$#" -ne 0 ]; then
    echo "Usage: bootstrap-user.sh [--force]" >&2
    exit 2
fi
if [ "$(id -u)" -eq 0 ]; then
    echo "bootstrap-user.sh must run as an unprivileged user" >&2
    exit 1
fi

mkdir -p "$STATE_DIR"
touch "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

for command_name in git vim zsh; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Missing image prerequisite: $command_name" >&2
        exit 1
    fi
done

FINGERPRINT="$({
    printf '%s\n' "$ANTIGEN_REV" "$VUNDLE_REV"
    printf '%s\n' 'zsh-users/zsh-syntax-highlighting' 'bureau'
    for input in "$ROOT/bootstrap-user.sh" "$ROOT/src/.vimrc" "$ROOT/src/.zshrc"; do
        git hash-object "$input"
    done
} | git hash-object --stdin)"

bootstrap_is_current() {
    [ -f "$MARKER" ] &&
        grep -qx "fingerprint=$FINGERPRINT" "$MARKER" &&
        [ -f "$HOME/antigen/antigen.zsh" ] &&
        [ -f "$HOME/.vim/bundle/Vundle.vim/autoload/vundle.vim" ] &&
        [ -d "$HOME/.vim/bundle/vim-colors-solarized" ]
}

if [ "$FORCE" = false ] && bootstrap_is_current; then
    echo "Dotfiles user bootstrap is current ($FINGERPRINT)"
    exit 0
fi

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    echo "Dotfiles user bootstrap is already running"
    exit 0
fi
cleanup() {
    rmdir "$LOCK_DIR" 2>/dev/null || true
}
on_error() {
    status=$?
    trap - ERR
    printf 'failed_at=%s\nstatus=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$status" > "$ERROR_FILE"
    echo "Dotfiles user bootstrap failed; see $LOG_FILE" >&2
    exit "$status"
}
trap cleanup EXIT
trap on_error ERR

checkout_managed_repo() {
    url="$1"
    destination="$2"
    revision="$3"

    if [ -e "$destination" ] && [ ! -d "$destination/.git" ]; then
        echo "$destination exists but is not a managed Git checkout" >&2
        return 1
    fi
    if [ ! -d "$destination/.git" ]; then
        temp_dir="${destination}.tmp.$$"
        rm -rf "$temp_dir"
        git clone --no-checkout "$url" "$temp_dir"
        git -C "$temp_dir" checkout --detach "$revision"
        mv "$temp_dir" "$destination"
    else
        git -C "$destination" fetch --quiet origin "$revision"
        git -C "$destination" checkout --quiet --detach "$revision"
    fi
}

echo "Reconciling persistent dotfiles tools ($FINGERPRINT)"
mkdir -p "$HOME/.vim/bundle"
checkout_managed_repo \
    https://github.com/zsh-users/antigen.git \
    "$HOME/antigen" \
    "$ANTIGEN_REV"
checkout_managed_repo \
    https://github.com/VundleVim/Vundle.vim.git \
    "$HOME/.vim/bundle/Vundle.vim" \
    "$VUNDLE_REV"

HOME="$HOME" zsh -fc '
    source "$HOME/antigen/antigen.zsh"
    antigen use oh-my-zsh
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen theme bureau
    antigen apply
'

vim -Nu "$ROOT/src/.vimrc" -n -es \
    -c 'set nomore' \
    -c 'PluginInstall!' \
    -c 'qa!'

if [ ! -d "$HOME/.vim/bundle/vim-colors-solarized" ]; then
    echo "Vim plugin installation did not produce vim-colors-solarized" >&2
    exit 1
fi

temp_marker="$MARKER.tmp.$$"
{
    printf 'schema=1\n'
    printf 'fingerprint=%s\n' "$FINGERPRINT"
    printf 'dotfiles_commit=%s\n' "$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || printf unknown)"
    printf 'completed_at=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
} > "$temp_marker"
mv "$temp_marker" "$MARKER"
rm -f "$ERROR_FILE"
echo "Dotfiles user bootstrap complete"
