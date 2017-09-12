#!/bin/zsh

source ../constants.sh
source ../shared/echo.sh
CONFIG=$_CONFIG_PATH

### CREATE SYMLINKS ###
echo_info "Creating symlinks..."
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
echo_info "Cloning apps..."
clone_app(){
 (cd $_SHELL_APPS_PATH && git clone $1)
}

clean-folder(){
 local destination=$1

 if [[ ! -d "$destination" ]]
  then
   echo_info "Folder $destination is not present. Creating a folder..."
   mkdir $destination
   echo_info "Folder created."
  else
   echo_info "Folder exists. Purging."
   rm -rf $destination/*
 fi
}

clean-folder $_SHELL_APPS_PATH

# liquiprompt
clone_app https://github.com/nojhan/liquidprompt.git

# z
clone_app https://github.com/rupa/z.git

# zsh syntax highlighting
clone_app https://github.com/zsh-users/zsh-syntax-highlighting.git

# zsh autosugestions
clone_app https://github.com/zsh-users/zsh-autosuggestions.git

# oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "source ~/shell_config/main.sh" >> ~/.zshrc
