prefix-functionname(){
  [[ "$1" == "-h" ]] && _show_help ${funcstack[1]} && return
  _check_arg $1 "ParamName"
  local first_variable=$1
  # function body here
}
