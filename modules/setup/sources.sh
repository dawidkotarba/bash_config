### setup ###

_aptinstall(){
   _help $1 && return
   _check_arg $1 "At least one program to install"
   echo_info "Installing: $@"
   sudo apt install -y $@
}
alias aptinstall=_aptinstall

_aptremove(){
   _help $1 && return
   _check_arg $1 "At least one program to remove"
   echo_info "Removing: $@"
   sudo apt remove -y $@
}
alias aptremove=_aptremove

_aptupdate(){
   _help $1 && return
   sudo apt update
   echo_info "apt update..."
}
alias aptupdate=_aptupdate

_addaptrepository(){
  _help $1 && return
  _check_arg $1 "Repository to be added"
  echo_info "Adding repository: $1"
  sudo add-apt-repository $1
  _aptupdate
}

setup-ranger(){
  _help $1 && return
  _aptinstall ranger caca-utils highlight atool w3m poppler-utils mediainfo
  ranger --copy-config=all
}

setup-pidgin(){
  _help $1 && return
  _aptinstall pidgin pidgin-sipe
}

setup-evolution(){
  _help $1 && return
  _aptinstall evolution evolution-plugins evolution-ews evolution-indicator
}

setup-atom(){
  _help $1 && return
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  _aptupdate
  _aptinstall atom

  echo_info "Installing: plugins"
  apm install minimap highlight-selected simple-drag-drop-text git-plus merge-conflicts
  apm install color-picker pigments file-icons intellij-idea-keymap linter-shellcheck

  #js
  apm install atom-beautify linter-csslint linter-htmlhint linter-eslint linter-less
  apm install linter-lesshint sort-lines editorconfig emmet
}

setup-sshserver(){
  _help $1 && return
  _aptinstall openssh-client openssh-server
  sudo systemctl restart sshd.service
}

setup-remmina(){
  _help $1 && return
  _aptinstall remmina remmina-plugin-vnc remmina-plugin-rdp
}

setup-openconnect(){
  _help $1 && return
  _aptinstall openconnect network-manager-openconnect-gnome
}

setup-openvpn(){
  _help $1 && return
  _aptinstall openvpn network-manager-openvpn-gnome resolvconf
}

setup-deepinscreenshot(){
  _help $1 && return
  _aptinstall deepin-screenshot
}

setup-dev(){
  _help $1 && return
  _aptinstall git tig ant maven gradle
  _aptinstall silversearcher-ag lnav meld
}

setup-node(){
  _help $1 && return
   curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  _aptinstall nodejs nodejs-legacy
}

setup-ruby(){
  _help $1 && return
  _aptinstall ruby-full rubygems build-essential zlib1g-dev liblzma-dev cmake jekyll
}

setup-jekyll(){
  _help $1 && return
  setup-ruby
  _aptinstall jekyll bundler
}

setup-socials(){
  _help $1 && return
  _aptinstall corebird
}

setup-ripgrep(){
  _help $1 && return
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb
  sudo dpkg -i ripgrep_0.8.1_amd64.deb
  rm ripgrep_0.8.1_amd64.deb
}

setup-funny(){
  _help $1 && return
  _aptinstall figlet cmatrix
}

setup-android(){
  _help $1 && return
  _aptinstall android-tools-adb android-tools-fastboot adb
}

setup-mysql(){
  _help $1 && return
  _aptinstall mysql-client mysql-server mysql-workbench
}

setup-pomodoro(){
  _help $1 && return
  _addaptrepository ppa:atareao/atareao
  _aptinstall pomodoro-indicator
}

setup-chrome(){
  _help $1 && return
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
}

setup-wireshark(){
  _help $1 && return
  _aptinstall wireshark
  sudo dpkg-reconfigure wireshark-common
  sudo adduser $USER wireshark
}

setup-acetoneiso(){
  _help $1 && return
  _aptinstall acetoneiso fuseiso mencoder
}

setup-essentials(){
  _help $1 && return
  # monitoring
  _aptinstall htop glances

  # Linux essentials
  _aptinstall tilda vim tree mtr net-tools shellcheck snapd samba

  # SSH
  _aptinstall sshpass
  setup-sshserver

  # Clipboard managers, mouse gestures
  _aptinstall easystroke clipit parcellite

  # autokey
  _aptinstall autokey-common autokey-gtk

  # notes, markdown
  _aptinstall nixnote2 retext

  # alien
  _aptinstall alien dpkg-dev debhelper build-essential

  # ranger
  setup-ranger

  # remmina - RDP
  setup-remmina

  # VPN
  setup-openvpn

  # others
  _aptinstall filezilla pinta radiotray synapse iptux
}

# Raspberry PI
setup-rpi-docker(){
  _help $1 && return
  curl -sSL https://get.docker.com | sh
}

setup-jdk9(){
  _help $1 && return
  _addaptrepository ppa:webupd9team/java
  _aptinstall oracle-java9-installer
}
