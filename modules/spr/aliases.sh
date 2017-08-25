spr_newbean(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "full class name"
  python $SHELL_MODULES_PATH/spr/spr_newbean.py $1 | xclip -selection clipboard
}
