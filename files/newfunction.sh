prefix-functionname(){
  [[ "$1" == "-h" ]] && __echo_info "Help information" && return
  __check $1 "ParamName"
  local first_variable=$1
  # function body here
}
