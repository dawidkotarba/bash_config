prefix-functionname(){
  _help $1 && return
  _check_arg $1 "parameter name"
  local first_variable=$1
  # function body here
}
alias functionname='prefix-functionnamed'
