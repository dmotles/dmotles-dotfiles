#!/bin/bash
set -e
set -u
#set -x

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $ROOT

ln -svf  $ROOT/.gitconfig ~/.gitconfig
ln -svf  $ROOT/.gitignore_global ~/.gitignore_global
ln -svf  $ROOT/.vimrc ~/.vimrc
ln -svf  $ROOT/.zshrc ~/.zshrc
ln -svfn  $ROOT/zsh ~/.zsh
echo "export DMOTLES_DOTFILES_ROOT=$ROOT" > ~/.dmotles-dotfiles-root

# Install vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || echo "Unable to install vundle. Maybe it's already installed?"

# Install/update plugins
vim +PluginInstall +qall
