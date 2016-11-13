#!/bin/bash

source ../dirs
CONFIG=$CONFIG_PATH

### CREATE SYMLINKS ###
create_symlink(){
 local target=$1
 local shortcut=$2
 rm -rf $shortcut
 ln -s $target $shortcut
}

create_symlink $CONFIG/.gitconfig ~/.gitconfig 
create_symlink $CONFIG/.vim ~/.vim
create_symlink $CONFIG/.vimrc ~/.vimrc

### CLONE APPS ###
clone_app(){
 (cd $BASH_APPS_PATH && git clone $1)
}

clone_app https://github.com/rupa/z.git
clone_app https://github.com/nojhan/liquidprompt.git

