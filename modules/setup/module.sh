### setup ###

_aptinstall(){
   _help $1 && return
   _check_arg $1 "At least one program to install"
   echo_info "Installing: $@"
   # Install each program in loop instead at once by $@
   # to prevent failing chain installations
   for program in "$@"
   do
      sudo apt install -y "$program"
   done
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

setup-doublecmd(){
  _help $1 && return
  _aptinstall doublecmd-gtk doublecmd-common
}

# Install calibre from the site to fix issues with Linux Mint 20
setup-calibre(){
  _help $1 && return
  # _aptinstall calibre
  sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
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
  wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
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

setup-dev(){
  _help $1 && return
  # Git
  _aptinstall git git-lfs tig

  # Java build tools
  _aptinstall ant maven gradle
  _aptinstall silversearcher-ag lnav meld

  # Python
  setup-python3

  # Ruby and Jekyll
  setup-ruby
  setup-jekyll
}

setup-node(){
  _help $1 && return
   curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  _aptinstall nodejs nodejs-legacy
}

setup-ruby(){
  _help $1 && return
  _aptinstall ruby-full rubygems build-essential zlib1g-dev liblzma-dev cmake
}

setup-python3(){
  _help $1 && return
  _aptinstall python3.8 python3.8-dev python3.8-distutils python3.8-venv
  _aptinstall python3-pip
}

setup-jekyll(){
  _help $1 && return
  setup-ruby
  _aptinstall bundler
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

setup-environment-xubuntu(){
  _help $1 && return
  _aptinstall xubuntu-desktop
}

setup-signal(){
  _help $1 && return
  curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
  echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
  sudo apt update && _aptinstall signal-desktop
}

setup-yubikey(){
  _help $1 && return
  _addaptrepository ppa:yubico/stable
  _aptinstall yubikey-personalization-gui yubikey-personalization yubikey-manager yubioath-desktop
  _aptinstall pcscd scdaemon gnupg2 pcsc-tools
}

setup-docker(){
  _help $1 && return
  _aptinstall docker-compose
}

setup-docker-jenkins(){
  _help $1 && return
  local container_name="jenkins-local"
  local port="8081"
  docker image pull jenkins/jenkins:lts
  docker volume create jenkinsvol
  docker container run -d -p ${port}:8080 -v jenkinsvol:/var/jenkins_home --name ${container_name} jenkins/jenkins:lts
  echo "Jenkins admin password:"
  docker container exec ${container_name} sh -c "cat /var/jenkins_home/secrets/initialAdminPassword"
  echo "Jenkins will run on ${port} with name "
}

# Raspberry PI
setup-rpi-docker(){
  _help $1 && return
  curl -sSL https://get.docker.com | sh
}

setup-sdkman(){
  _help $1 && return
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
}

setup-woeusb(){
  _help $1 && return
  _addaptrepository ppa:nilarimogard/webupd8
  _aptinstall woeusb
}

setup-unison(){
  _help $1 && return
  _aptinstall unison unison-gtk
}

setup-enpass(){
  _help $1 && return
  sudo echo "deb https://apt.enpass.io/ stable main" > /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
  _aptupdate
  _aptinstall enpass
}

setup-brave-browser(){
  _help $1 && return
  _aptinstall apt-transport-https curl gnupg
  curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
  echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  _aptupdate
  _aptinstall brave-browser
}

setup-obs-studio(){
  _help $1 && return
  _aptinstall ffmpeg
  _addaptrepository ppa:obsproject/obs-studio
  _aptinstall obs-studio
}

setup-essentials(){
  _help $1 && return

  # monitoring
  _aptinstall htop glances

  # Linux essentials
  _aptinstall tilda vim tree mtr net-tools shellcheck samba xclip whois
  _aptinstall grub-customizer

  # Images
  _aptinstall gthumb imagemagick flameshot

  # SSH
  _aptinstall sshpass
  setup-sshserver

  # Clipboard managers, mouse gestures
  _aptinstall easystroke parcellite

  # autokey
  _aptinstall autokey-common autokey-gtk

  # notes, markdown
  _aptinstall nixnote2 retext

  # alien
  _aptinstall alien dpkg-dev debhelper build-essential

  # Tool for Logitech devices
  _aptinstall solaar

  # others
  _aptinstall filezilla pinta synapse iptux klavaro

  setup-dev
  setup-ranger
  setup-doublecmd
  setup-remmina
  setup-openvpn
  setup-yubikey
  setup-calibre
  setup-unison
}

setup-logitech-m570(){
  _help $1 && return
  _aptinstall solaar
  sudo echo $'Section "InputClass"\nIdentifier "Logitech M570"\nMatchProduct "Logitech M570"\nDriver "libinput"\nOption "ScrollMethod" "button"\nOption "ScrollButton" "3"\nOption "MiddleEmulation" "on"\nEndSection' > /usr/share/X11/xorg.conf.d/99-M570Logitech.conf
}

setup-logitech-m575(){
  _help $1 && return
  _aptinstall solaar
  sudo echo $'Section "InputClass"\nIdentifier "Logitech ERGO M575"\nMatchProduct "Logitech ERGO M575"\nDriver "libinput"\nOption "ScrollMethod" "button"\nOption "ScrollButton" "3"\nOption "MiddleEmulation" "on"\nEndSection' > /usr/share/X11/xorg.conf.d/99-M575Logitech.conf
}

setup-new-daw(){
  _help $1 && return
  setup-essentials
  setup-dev
  setup-node
  setup-ruby
  setup-jekyll
  setup-python3
  setup-ranger
  setup-doublecmd
  setup-atom
  setup-sshserver
  setup-yubikey
  setup-chrome
  setup-signal
  setup-enpass
  setup-logitech-m570
}

setup-new-agu(){
  _help $1 && return
  setup-essentials
  setup-ranger
  setup-doublecmd
  setup-atom
  setup-sshserver
  setup-yubikey
  setup-chrome
  setup-signal
  setup-enpass
  setup-logitech-m575
}
