prefix-functionname(){
  [[ "$1" == "-h" ]] && __echo_info "Help information" && return
  __check $1 "Check first argument message"
  local first_variable=$1
  # function body here
}
