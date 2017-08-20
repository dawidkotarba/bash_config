#!/bin/zsh

source ../aliases.sh
CONFIG=$CONFIG_PATH

### CREATE SYMLINKS ###
__echo_info "Creating symlinks..."
create_symlink(){
 local target=$1
 local shortcut=$2
 rm -rf $shortcut
 ln -s $target $shortcut
}

# symlinks with configuration
create_symlink $CONFIG/gitconfig ~/.gitconfig
create_symlink $CONFIG/vim ~/.vim
create_symlink $CONFIG/vimrc ~/.vimrc
create_symlink $CONFIG/tilda ~/.config/tilda

### CLONE APPS ###
__echo_info "Cloning apps..."
clone_app(){
 (cd $SHELL_APPS_PATH && git clone $1)
}

clean-folder(){
 local destination=$1

 if [[ ! -d "$destination" ]]
  then
   __echo_info "Folder $destination is not present. Creating a folder..."
   mkdir $destination
   __echo_info "Folder created."
  else
   __echo_info "Folder exists. Purging."
   rm -rf $destination/*
 fi
}

clean-folder $SHELL_APPS_PATH

# liquiprompt
clone_app https://github.com/nojhan/liquidprompt.git

# z
clone_app https://github.com/rupa/z.git

### zsh and oh-my-zsh ###
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "source ~/shell_config/aliases.sh" >> ~/.zshrc
