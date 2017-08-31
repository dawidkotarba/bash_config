spr-newbean(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "full class name"
  local class_name=$1
  if [[ -z $class_name ]] && class_name=`xclip -o`
  python $__SHELL_MODULES_PATH/spr/spr_newbean.py $class_name | xclip -selection clipboard
}
alias bean=spr-newbean
