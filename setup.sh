#!/usr/bin/env bash
_SHELL_CONFIG_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
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
   mkdir -p ${destination}
   echo_info "Folder created."
  else
   echo_info "Folder exists. Purging."
   rm -rf ${destination}/*
 fi
}

# Whiptail configuration
export NEWT_COLORS='root=,black
    roottext=red,white
    entry=red,white'
SETUP_WINDOW_TITLE="Shell configuration setup"
WINDOW_HEIGHT=10
WINDOW_WIDTH=100

function show_info_box(){
    whiptail --title "Info:" --backtitle "${SETUP_WINDOW_TITLE}" --msgbox "$1" ${WINDOW_HEIGHT} ${WINDOW_WIDTH}
}

function show_yesno_box(){
    whiptail --title "Conditional action:" --backtitle "${SETUP_WINDOW_TITLE}" --yesno "$1" ${WINDOW_HEIGHT} ${WINDOW_WIDTH}
}

function show_input_box(){
    whiptail --title "User input:" --backtitle "${SETUP_WINDOW_TITLE}" --inputbox "$1" ${WINDOW_HEIGHT} ${WINDOW_WIDTH} 3>&1 1>&2 2>&3
}

function wait_for_keypress(){
  local color=`tput setaf 4`
  local reset=`tput sgr0`
  local message="Press any key to continue..."

  if [[ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]]; then
     read "?${color}${message}${reset}"
  elif [[ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]]; then
     read -p "${color}${message}${reset}"
  else
     read -p "${color}${message}${reset}"
  fi
}

### EXECUTION ###
if show_yesno_box "Install git?"; then
  sudo apt install git
fi

if show_yesno_box "Install git hooks?"; then
  (cd githooks; ./install.sh)
fi


if show_yesno_box "Create symbolic links for applications configs (git, vim, tilda, easystroke)?"; then
  echo_info "Creating symlinks..."
  create_symlink ${CONFIG}/gitconfig ~/.gitconfig
  create_symlink ${CONFIG}/vim ~/.vim
  create_symlink ${CONFIG}/vimrc ~/.vimrc
  create_symlink ${CONFIG}/tilda ~/.config/tilda
  create_symlink ${CONFIG}/easystroke ~/.easystroke
fi

if show_yesno_box "Clone terminal tools from git?"; then
  clean-folder ${_SHELL_APPS_PATH}
  clone_app https://github.com/nojhan/liquidprompt.git
  clone_app https://github.com/rupa/z.git
  clone_app https://github.com/zsh-users/zsh-syntax-highlighting.git
  clone_app https://github.com/zsh-users/zsh-autosuggestions.git
fi

if show_yesno_box "Install zsh shell?"; then
  sudo apt install zsh
fi

if show_yesno_box "Install oh-my-zsh? If yes, exit the ZSH shell once the installation is complete to come back to this script."; then
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

if show_yesno_box "Clone Oh my ZSH plugins?"; then
  git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify
fi

if show_yesno_box "Add configuration entries to .zshrc?"; then
 sed -i "/^plugins=.*/c plugins=(git svn mvn gradle encode64 docker sudo tig urltools web-search history-substring-search cp)" ~/.zshrc
  [[ -z $(grep "source ~/shell_config/main.sh" ~/.zshrc) ]] && (echo "source ~/shell_config/main.sh" >> ~/.zshrc)
fi

show_info_box "Setup complete:)"
