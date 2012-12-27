#!/bin/bash

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

make_link() {
	local file=$1
	local source=$DIR/$file
	local target=$HOME/$file
	# target exists and is not symlink
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		/bin/mv "$target" "${target}.orig"
	fi
	ln -s -i "$source" "$target" 
}


FILELIST="
.gitconfig
.gitignore_global
.vim
vimplugins
.vimrc
.zshrc
.zsh
.zshenv
"

for file in `echo $FILELIST`; do
	make_link "$file"
done
