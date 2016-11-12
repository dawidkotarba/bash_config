#!/bin/bash

source ../dirs
CONFIG=$CONFIG_PATH

### SYMLINKS ###
__create_symlink(){
 local TARGET=$1
 local SHORTCUT=$2
 rm -rf $SHORTCUT
 ln -s $TARGET $SHORTCUT
}

__create_symlink $CONFIG/.gitconfig ~/.gitconfig 
__create_symlink $CONFIG/.vim ~/.vim
__create_symlink $CONFIG/.vimrc ~/.vimrc

### APPS ###
__clone_app(){
 (cd $BASH_APPS_PATH && git clone $1)
}

__clone_app https://github.com/rupa/z.git
__clone_app https://github.com/nojhan/liquidprompt.git

