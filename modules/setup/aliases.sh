### setup ###

_aptinstall(){
   [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
   checkarg $1 "at least one program to install"
   echo_info "Installing $@"
   apt install $@
}

setup-ranger(){
  _aptinstall ranger caca-utils highlight atool w3m poppler-utils mediainfo
  ranger --copy-config=all
}

setup-pidgin(){
  _aptinstall pidgin pidgin-sipe
}

setup-evolution(){
  _aptinstall evolution evolution-ews
}
