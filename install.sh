#!/bin/bash
set -e
set -u
set -x

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $ROOT

OS=$(uname -s)


case $OS in
    Darwin)
        echo -n 'Checking for homebrew...'
        if ! command -v brew; then
            echo not installed
            xcode-select --install || echo 'xcode dev tools already installed';
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
        fi
        echo -n 'Checking for fortune command...'
        if ! command -v fortune; then
            brew install fortune
        fi
        if ! command -v hg; then
            brew install hg
        fi
        ;;
    Linux)
        if ! command -v fortune; then
            sudo apt-get install fortune-mod
        fi
        ;;
esac


git clone https://github.com/zsh-users/antigen.git ~/antigen 2> /dev/null || echo 'Unable to install antigen. might be installed already.'
git --git-dir ~/antigen/.git --work-tree ~/antigen checkout v2.1.1

# hg prompt, needed for some themes...
hg clone https://bitbucket.org/sjl/hg-prompt ~/.hg-prompt 2> /dev/null || echo '.hg-prompt already exists... continuing.'

echo "export DMOTLES_DOTFILES_ROOT=$ROOT" > ~/.dmotles-dotfiles-root
ln -svf  $ROOT/.gitconfig ~/.gitconfig
ln -svf  $ROOT/.gitignore_global ~/.gitignore_global
ln -svf  $ROOT/.vimrc ~/.vimrc
ln -svf  $ROOT/.zshrc ~/.zshrc
ln -svf  $ROOT/.hgrc ~/.hgrc
ln -svf  $ROOT/tmux.conf ~/.tmux.conf

# Install vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || echo "Unable to install vundle. Maybe it's already installed?"


# Install/update plugins
vim +PluginInstall +qall
