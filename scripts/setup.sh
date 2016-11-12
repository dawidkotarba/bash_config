#!/bin/bash

source ../dirs
CONFIG=$CONFIG_PATH

### CREATE SYMLINKS ###
create_symlink(){
 local TARGET=$1
 local SHORTCUT=$2
 rm -rf $SHORTCUT
 ln -s $TARGET $SHORTCUT
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

