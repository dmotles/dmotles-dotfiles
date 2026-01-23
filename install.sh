#!/bin/bash
set -e
set -u
set -x

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $ROOT

OS=$(uname -s)

# Detect non-interactive mode for Coder, Codespaces, or manual override
NONINTERACTIVE=false
if [ "${CODER:-}" = "true" ] || [ "${CODESPACES:-}" = "true" ] || [ "${DOTFILES_NONINTERACTIVE:-}" = "1" ]; then
    NONINTERACTIVE=true
    echo "Running in non-interactive mode"
fi

# Minimal mode: skip apt-get installs, zsh, fzf, etc. Just symlink configs.
# Default to minimal in Coder unless DOTFILES_FULL=1
MINIMAL_MODE=false
if [ "${CODER:-}" = "true" ] && [ "${DOTFILES_FULL:-}" != "1" ]; then
    MINIMAL_MODE=true
    echo "Running in minimal mode (Coder detected). Use DOTFILES_FULL=1 for full install."
fi

# Allow --full flag to override minimal mode
if [ "${1:-}" = "--full" ]; then
    MINIMAL_MODE=false
    echo "Full install requested via --full flag"
fi

# Allow --minimal flag to force minimal mode
if [ "${1:-}" = "--minimal" ]; then
    MINIMAL_MODE=true
    echo "Minimal install requested via --minimal flag"
fi

# Timeout in seconds for apt to wait for dpkg lock
APT_LOCK_TIMEOUT=120

function -pkg-mgr-install-if-not-exists() {
    local testcmd="$1"
    local pkg="$2"
    local pkgmgr="$3"
    echo -n "Checking for $testcmd command..."
    if ! command -v "$testcmd"; then
        echo " not installed. Installing."
        $pkgmgr install "$pkg"
    fi
}


function -brew-install-if-not-exist() {
    -pkg-mgr-install-if-not-exists "$1" "$2" brew
}


function -apt-get-install-if-not-exist() {
    -pkg-mgr-install-if-not-exists "$1" "$2" "sudo apt-get -o DPkg::Lock::Timeout=$APT_LOCK_TIMEOUT -y"
}


function -safe-git-checkout() {
    local tgtdir="$1"
    local rev="$2"
    if [ -n "$rev" ]; then
        git --git-dir "$tgtdir/.git" --work-tree "$tgtdir" checkout "$rev"
        git --git-dir "$tgtdir/.git" --work-tree "$tgtdir" pull origin "$rev"
    else
        git --git-dir "$tgtdir/.git" --work-tree "$tgtdir" pull origin master
    fi
}


function -safe-git-clone() {
    local repo="$1"
    local tgtdir="$2"
    local rev="${3:-}"
    if [ -d "$tgtdir" ]; then
        if [ -d "$tgtdir/.git" ]; then
            -safe-git-checkout "$tgtdir" "$rev"
        else
            echo "$tgtdir is not empty and is not a git repo." >&2
            exit 1
        fi
    else
        if [ -n "$rev" ]; then
            git clone -b "$rev" -- "$repo" "$tgtdir"
        else
            git clone "$repo" "$tgtdir"
        fi
    fi
}


# Always set up dotfiles root (needed for bashrc reminder)
echo "export DMOTLES_DOTFILES_ROOT=$ROOT" > ~/.dmotles-dotfiles-root

if [ "$MINIMAL_MODE" = true ]; then
    echo "Minimal mode: skipping package installs, zsh, fzf, vim plugins..."
else
    # Full install: packages, zsh, fzf, vim, etc.
    case $OS in
        Darwin)
            echo -n 'Checking for homebrew...'
            if ! command -v brew; then
                echo not installed
                xcode-select --install || echo 'xcode dev tools already installed';
                /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
            fi
            -brew-install-if-not-exist fortune fortune
            -brew-install-if-not-exist hg hg
            -brew-install-if-not-exist cmake cmake
            -brew-install-if-not-exist fzf fzf
            brew install fzf
            $(brew --prefix)/opt/fzf/install --all --no-update-rc
            ;;
        Linux)
            sudo apt-get -o DPkg::Lock::Timeout=$APT_LOCK_TIMEOUT update
            -apt-get-install-if-not-exist fortune fortune-mod || true
            -apt-get-install-if-not-exist cmake cmake
            -apt-get-install-if-not-exist g++ g++
            -safe-git-clone https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all --no-update-rc
            ;;
    esac

    if ! command -v zsh; then
        if [ "$NONINTERACTIVE" = true ]; then
            echo "zsh not found, installing..."
            sudo apt-get -o DPkg::Lock::Timeout=$APT_LOCK_TIMEOUT -y install zsh
        else
            echo 'Install zsh first, bro.'
            exit 1
        fi
    fi

    -safe-git-clone https://github.com/zsh-users/antigen.git ~/antigen 'v2.1.1' 
    -safe-git-clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# does the symlink magic
if [ "$NONINTERACTIVE" = true ]; then
    python3 symlink_all.py --non-interactive
else
    python3 symlink_all.py
fi

# Install vim plugins (skip in minimal mode - it's slow and often not needed)
if [ "$MINIMAL_MODE" = true ]; then
    echo "Vim plugins not installed (minimal mode)."
    echo "  To install later: vim -c 'PluginInstall!' -c 'PluginClean' -c 'qa!'"
else
    # Use yes to auto-answer any "Press ENTER" prompts from errors
    yes '' | vim -c 'set nomore' -c 'PluginInstall!' -c 'PluginClean' -c 'qa!' || true
fi

if [ "$MINIMAL_MODE" = true ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Minimal dotfiles install complete!"
    echo "  Installed: git, tmux, gdb, hg configs + bashrc"
    echo "  Run 'dotfiles-full-install' or '$ROOT/install.sh --full' for full setup"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi
