#!/bin/bash
source constants.sh
source shared/echo.sh
CONFIG=${_CONFIG_PATH}

### FUNCTIONS ###
create_symlink(){
 local target=$1
 local shortcut=$2
 rm -rf ${shortcut}
 ln -s ${target} ${shortcut}
}

clone_app(){
 (cd ${_SHELL_APPS_PATH} && echo_info "Cloning from $1" && git clone $1)
}

clean-folder(){
 local destination=$1
 if [[ ! -d "$destination" ]]
  then
   echo_info "Folder $destination is not present. Creating a folder..."
   mkdir ${destination}
   echo_info "Folder created."
  else
   echo_info "Folder exists. Purging."
   rm -rf ${destination}/*
 fi
}

show-dialog(){
  whiptail --backtitle "Setup script" --title "Setup script option:" --yesno "$1" 7 60
}

### EXECUTION ###
show-dialog "Create symbolic links for applications configs (git, vim, tilda)?"; response=$?
case ${response} in
  0)
  echo_info "Creating symlinks..."
  create_symlink ${CONFIG}/gitconfig ~/.gitconfig
  create_symlink ${CONFIG}/vim ~/.vim
  create_symlink ${CONFIG}/vimrc ~/.vimrc
  create_symlink ${CONFIG}/tilda ~/.config/tilda
esac

show-dialog "Clone terminal tools from git?"; response=$?
case ${response} in
  0)
  clean-folder ${_SHELL_APPS_PATH}
  clone_app https://github.com/nojhan/liquidprompt.git
  clone_app https://github.com/rupa/z.git
  clone_app https://github.com/zsh-users/zsh-syntax-highlighting.git
  clone_app https://github.com/zsh-users/zsh-autosuggestions.git
esac

show-dialog "Install zsh shell?"; response=$?
case ${response} in
  0) sudo apt install zsh
esac

show-dialog "Install oh-my-zsh?"; response=$?
case ${response} in
  0) sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
esac

show-dialog "Add configuration entries to .zshrc?"; response=$?
case ${response} in
  0)
  sed -i "/^plugins=.*/c plugins=(git svn mvn gradle encode64 docker sudo tig urltools web-search history-substring-search cp)" ~/.zshrc
  [[ -z $(grep "source ~/shell_config/main.sh" ~/.zshrc) ]] && (echo "source ~/shell_config/main.sh" >> ~/.zshrc)
esac
tput clear
echo_info "Setup complete."
