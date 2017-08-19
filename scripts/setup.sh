#!/bin/zsh

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
 (cd $SHELL_APPS_PATH && git clone $1)
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

clean-folder $SHELL_APPS_PATH

# z
clone_app https://github.com/rupa/z.git

### Update.zshrc ###
echo "source ~/shell_config/aliases.sh" >> ~/.zshrc
