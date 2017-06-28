#!/bin/bash
set -e
set -u
set -x

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $ROOT

OS=$(uname -s)


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
    -pkg-mgr-install-if-not-exists "$1" "$2" "sudo apt-get"
}


function -safe-git-checkout() {
    local tgtdir="$1"
    local rev="$2"
    if [ -n "$rev" ]; then
        git --git-dir "$tgtdir/.git" --work-tree "$tgtdir" checkout "$rev"
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
        ;;
    Linux)
        -apt-get-install-if-not-exist fortune fortune-mod
        ;;
esac

-safe-git-clone https://github.com/zsh-users/antigen.git ~/antigen 'v2.1.1' 

# hg prompt, needed for some themes...
if [ ! -d ~/.hg-prompt ]; then
    hg clone https://bitbucket.org/sjl/hg-prompt ~/.hg-prompt
fi

echo "export DMOTLES_DOTFILES_ROOT=$ROOT" > ~/.dmotles-dotfiles-root
ln -svf  $ROOT/.gitconfig ~/.gitconfig
ln -svf  $ROOT/.gitignore_global ~/.gitignore_global
ln -svf  $ROOT/.zshrc ~/.zshrc
ln -svf  $ROOT/.hgrc ~/.hgrc
ln -svf  $ROOT/.hgignore_global ~/.hgignore_global
ln -svf  $ROOT/tmux.conf ~/.tmux.conf
ln -svf  $ROOT/vimrc.before.fork ~/.vimrc.before.fork
ln -svf  $ROOT/vimrc.fork ~/.vimrc.fork

# Install motles spf
if [ ! -d ~/.spf13-vim-3 ]; then
    curl https://raw.githubusercontent.com/dmotles/spf13-vim/3.0/bootstrap.sh -L | \
        REPO_URI=https://github.com/dmotles/spf13-vim.git sh
fi
