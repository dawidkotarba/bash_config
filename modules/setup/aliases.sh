### setup ###

_aptinstall(){
   [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
   checkarg $1 "At least one program to install"
   echo_info "Installing: $@"
   apt install $@
}

_aptrepository(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Repository to be added"
  echo_info "Adding repository: $1"
  sudo add-apt-repository $1
  echo_info "apt update..."
  apt update
}

setup-ranger(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall ranger caca-utils highlight atool w3m poppler-utils mediainfo
  ranger --copy-config=all
}

setup-pidgin(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall pidgin pidgin-sipe
}

setup-evolution(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall evolution evolution-ews
}

setup-atom(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall atom

  echo_info "Installing: plugins"
  apm install minimap highlight-selected simple-drag-drop-text git-plus merge-conflicts
  apm install color-picker pigments file-icons intellij-idea-keymap

  #js
  apm install atom-beautify linter-csslint linter-htmlhint linter-eslint linter-less
  apm install linter-lesshint sort-lines editorconfig emmet
}

setup-flux(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptrepository ppa:nathan-renniewaldock/flux
  _aptinstall fluxgui
}

setup-ssh(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall openssh-client openssh-server
  sudo systemctl restart sshd.service
}

setup-openconnect(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall openconnect network-manager-openconnect-gnome
}

setup-fuzzy(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
  sudo dpkg -i fzy_0.9-1_amd64.deb
}

setup-tools(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _aptinstall htop glances tilda clipit synapse tig meld filezilla retext
}

# Raspberry PI
setup-rpi-docker(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  curl -sSL https://get.docker.com | sh
}
