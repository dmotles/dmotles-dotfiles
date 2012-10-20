# The master dotfiles for dmotles
This is my current attempt at configuring my system and my VIM to act as IDE, and saving it for posterity's sake.

# Install (Mac OSX and possibly other operating systems)
1. Install [homebrew](http://mxcl.github.com/homebrew/). Pay attention to any warnings or errors and try to fix those.
2. Run the following:
```bash
brew install autoconf bash-completion ctags dos2unix git
```
3. Pull down repo into user's home folder :
```bash
git clone git@github.com:dmotles/dmotles-dotfiles.git`
```
4. You'll likely have to move data out into the home folder (i.e. the bash configs etc.) to make it so the .dotfiles are
actually used by the system. At the moment I have not devised a clever way to get around this like spf13 has.
5. Initialize and update submodules
```bash
git submodule init && git submodule update
```
6. Symlinks:
```bash
export endpath=.spf13-vim-3
ln -s -f $endpath/.vimrc $HOME/.vimrc
ln -s -f $endpath/.vimrc.fork $HOME/.vimrc.fork
ln -s -f $endpath/.vimrc.bundles $HOME/.vimrc.bundles
ln -s -f $endpath/.vimrc.bundles.fork $HOME/.vimrc.bundles.fork
ln -s -f $endpath/.vim $HOME/.vim
```
7. Setup vundle:
```bash
if [ ! -d $endpath/.vim/bundle ]; then
    mkdir -p $endpath/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi

echo "update/install plugins using Vundle"
vim -u $endpath/.vimrc.bundles - +BundleInstall! +BundleClean +qall
```
