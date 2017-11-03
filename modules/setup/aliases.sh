### setup ###

_aptinstall(){
   [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
   checkarg $1 "at least one program to install"
   echo_info "Installing: $@"
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

setup-atom(){
  _aptinstall atom

  echo_info "Installing: plugins"
  apm install minimap highlight-selected simple-drag-drop-text git-plus merge-conflicts
  apm install color-picker pigments file-icons intellij-idea-keymap

  #js
  apm install atom-beautify linter-csslint linter-htmlhint linter-eslint linter-less
  apm install linter-lesshint sort-lines editorconfig emmet
}
