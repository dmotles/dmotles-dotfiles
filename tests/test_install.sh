#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$TEST_HOME"' EXIT

HOME="$TEST_HOME" CODER=true "$ROOT/install.sh" --links-only
HOME="$TEST_HOME" CODER=true "$ROOT/install.sh" --links-only

test -L "$TEST_HOME/.zshrc"
test -L "$TEST_HOME/.vimrc"
test -L "$TEST_HOME/.bashrc.d/99-dotfiles-reminder.sh"
grep -q "DMOTLES_DOTFILES_ROOT" "$TEST_HOME/.dmotles-dotfiles-root"

if grep -Eq '\b(apt-get|brew|sudo|/usr/local)\b' "$ROOT/bootstrap-user.sh"; then
    echo "bootstrap-user.sh contains a system-level operation" >&2
    exit 1
fi

HOME="$TEST_HOME" vim -Nu "$TEST_HOME/.vimrc" -n -es -c 'qa!'
HOME="$TEST_HOME" zsh -dfc 'source "$HOME/.zshrc"'
