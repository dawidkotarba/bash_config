#!/bin/bash

source ../dirs.sh
CONFIG=$CONFIG_PATH

### CREATE SYMLINKS ###
echo "Creating symlinks..."
create_symlink(){
 local target=$1
 local shortcut=$2
 rm -rf $shortcut
 ln -s $target $shortcut
}

create_symlink $CONFIG/gitconfig ~/.gitconfig
create_symlink $CONFIG/vim ~/.vim
create_symlink $CONFIG/vimrc ~/.vimrc

### CLONE APPS ###
echo "Cloning apps..."
clone_app(){
 (cd $BASH_APPS_PATH && git clone $1)
}

clean-folder(){
 local destination=$1

 if [[ ! -d "$destination" ]]
  then
   echo "Folder $destination is not present. Creating a folder..."
   mkdir $destination
   echo "Folder created."
  else
   echo "Folder exists. Purging."
   rm -rf $destination/*
 fi
}

clean-folder $BASH_APPS_PATH

# z
clone_app https://github.com/rupa/z.git

# liquiprompt
clone_app https://github.com/nojhan/liquidprompt.git


### Update .bashrc ###
echo "Updating .bashrc file..."
echo "source ~/bash_config/aliases.sh" >> ~/.bashrc

### Bash settings ###
# shopt
echo "Applying bash settings..."
shopt -s cdspell
shopt -s nocaseglob
