### clip ###
_requires xclip

clip-file(){
  [[ "$1" == "-h" ]] && show_help ${funcstack[1]} && return
  local file_name=$1
  _filetoclipboard ${file_name}
}

clip-targets(){
  [[ "$1" == "-h" ]] && show_help ${funcstack[1]} && return
  xclip -selection clipboard -t TARGETS -o
}

clip-toimage(){
  [[ "$1" == "-h" ]] && show_help ${funcstack[1]} && return
  xclip -selection clipboard -t image/png -o > "`_get-desktop-path`/`_get-date`.png"
}

clip-totext(){
  [[ "$1" == "-h" ]] && show_help ${funcstack[1]} && return
  xclip -selection clipboard -o > "`_get-desktop-path`/`_get-date`.txt"
}
