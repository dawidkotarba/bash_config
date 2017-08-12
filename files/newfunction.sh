prefix-functionname(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  __check $1 "ParamName"
  local first_variable=$1
  # function body here
}
