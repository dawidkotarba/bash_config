### clip ###
_requires xclip

_get-desktop-path(){
  echo `xdg-user-dir DESKTOP`
}

_get-date(){
  echo `date +%Y-%m-%d_%T`
}

clip-targets(){
  xclip -selection clipboard -t TARGETS -o
}

clip-toimage(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  xclip -selection clipboard -t image/png -o > "`_get-desktop-path`/`_get-date`.png"
}

clip-totext(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  xclip -selection clipboard -o > "`_get-desktop-path`/`_get-date`.txt"
}
