#!/bin/bash
set -e
set -u
set -x

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $ROOT

ln -svf  $ROOT/.gitconfig ~/.gitconfig
ln -svf  $ROOT/.gitignore_global ~/.gitignore_global
