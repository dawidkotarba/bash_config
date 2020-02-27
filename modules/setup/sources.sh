### setup ###

_aptinstall(){
   ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
   checkarg $1 "At least one program to install"
   echo_info "Installing: $@"
   sudo apt install $@
}

_aptupdate(){
   ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
   sudo apt update
   echo_info "apt update..."
}

_addaptrepository(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Repository to be added"
  echo_info "Adding repository: $1"
  sudo add-apt-repository $1
  _aptupdate
}

setup-unattended-upgrades(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall unattended-upgrades
  sudo dpkg-reconfigure --priority=low unattended-upgrades
}

setup-ranger(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall ranger caca-utils highlight atool w3m poppler-utils mediainfo
  ranger --copy-config=all
}

setup-autokey(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall autokey-common autokey-gtk
}

setup-pidgin(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall pidgin pidgin-sipe
}

setup-evolution(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall evolution evolution-plugins evolution-ews
}

setup-atom(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  _aptupdate
  _aptinstall atom

  echo_info "Installing: plugins"
  apm install minimap highlight-selected simple-drag-drop-text git-plus merge-conflicts
  apm install color-picker pigments file-icons intellij-idea-keymap

  #js
  apm install atom-beautify linter-csslint linter-htmlhint linter-eslint linter-less
  apm install linter-lesshint sort-lines editorconfig emmet
}

setup-flux(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _addaptrepository ppa:nathan-renniewaldock/flux
  _aptinstall fluxgui
}

setup-sshserver(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall openssh-client openssh-server
  sudo systemctl restart sshd.service
}

setup-openconnect(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall openconnect network-manager-openconnect-gnome
}

setup-fuzzy(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
  sudo dpkg -i fzy_0.9-1_amd64.deb
}

setup-alien(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall alien dpkg-dev debhelper build-essential
}

setup-tools(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall htop glances tilda clipit parcellite synapse vim tree mtr nixnote2
  _aptinstall filezilla retext xclip radiotray pinta net-tools sshpass
}

setup-deepin(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall deepin-screenshot
}

setup-dev(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall git tig ant maven gradle
  _aptinstall silversearcher-ag lnav meld
}

setup-node(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
   curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  _aptinstall nodejs nodejs-legacy
}

setup-socials(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall corebird
}

setup-ripgrep(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb
  sudo dpkg -i ripgrep_0.8.1_amd64.deb
  rm ripgrep_0.8.1_amd64.deb
}

setup-funny(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall figlet cmatrix
}

setup-android(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall android-tools-adb android-tools-fastboot adb
}

# ubuntu tools, themes and icons
setup-ubuntu-tools(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall ubuntu-restricted-extras gnome-tweak-tool gnome-shell-pomodoro network-manager-openconnect-gnome
}

setup-icons-moka(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _addaptrepository ppa:moka/stable
  _aptinstall gnome-tweak-tool
  _aptinstall moka-icon-theme
}

setup-theme-communitheme(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _addaptrepository ppa:communitheme/ppa
  _aptinstall ubuntu-communitheme-session
}

setup-mysql(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _aptinstall mysql-client mysql-server mysql-workbench
}

setup-pomodoro(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _addaptrepository ppa:atareao/atareao
  _aptinstall pomodoro-indicator
}

setup-chrome(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
}

# Raspberry PI
setup-rpi-docker(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  curl -sSL https://get.docker.com | sh
}

# Oracle JDK
setup-jdk8(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _addaptrepository ppa:webupd8team/java
  _aptinstall oracle-java8-installer
}

setup-jdk9(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  _addaptrepository ppa:webupd9team/java
  _aptinstall oracle-java9-installer
}
