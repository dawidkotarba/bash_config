### clip ###

clip-toimage(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local desktopPath=`xdg-user-dir DESKTOP`
  xclip -selection clipboard -t image/png -o > "$desktopPath/`date +%Y-%m-%d_%T`.png"
}
