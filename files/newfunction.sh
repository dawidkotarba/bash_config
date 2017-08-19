prefix-functionname(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __check $1 "ParamName"
  local first_variable=$1
  # function body here
}
