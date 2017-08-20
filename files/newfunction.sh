prefix-functionname(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "ParamName"
  local first_variable=$1
  # function body here
}
