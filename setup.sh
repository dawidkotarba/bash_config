#!/bin/bash
source constants.sh
source shared/echo.sh
CONFIG=$_CONFIG_PATH

### FUNCTIONS ###
create_symlink(){
 local target=$1
 local shortcut=$2
 rm -rf $shortcut
 ln -s $target $shortcut
}

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

### EXECUTION ###
echo_arrow "Create symbolic links for applications configs (git, vim, tilda)? (y/n)"; read x
if [[ "$x" = "y" ]]; then
  echo_info "Creating symlinks..."
  create_symlink $CONFIG/gitconfig ~/.gitconfig
  create_symlink $CONFIG/vim ~/.vim
  create_symlink $CONFIG/vimrc ~/.vimrc
  create_symlink $CONFIG/tilda ~/.config/tilda
fi

echo_arrow "Clone terminal tools from git? (y/n)"; read x
if [[ "$x" = "y" ]]; then
  clean-folder $_SHELL_APPS_PATH
  clone_app https://github.com/nojhan/liquidprompt.git
  clone_app https://github.com/rupa/z.git
  clone_app https://github.com/zsh-users/zsh-syntax-highlighting.git
  clone_app https://github.com/zsh-users/zsh-autosuggestions.git
fi

echo_arrow "Install oh-my-zsh? (y/n)"; read x
if [[ "$x" = "y" ]]; then
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

echo_arrow "Add configuration entries to .zshrc? (y/n)"; read x
if [[ "$x" = "y" ]]; then
  sed -i "/^plugins=.*/c plugins=(git svn mvn gradle encode64 docker sudo tig urltools web-search history-substring-search cp)" ~/.zshrc
  [[ -z $(grep "source ~/shell_config/main.sh" ~/.zshrc) ]] && (echo "source ~/shell_config/main.sh" >> ~/.zshrc)
fi

echo_info "Setup complete."
