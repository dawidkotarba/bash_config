####################
# Helps and checks #
####################

# Constants:
HELP_SUFFIX=_help_

# Functions:

_help(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && _show_help ${funcstack[2]}
}

_show_help(){
  _check_arg $1 "Funciton name that is translated to related variable name"
  local help_variable_name=`echo "$HELP_SUFFIX$1" | tr - _`
  local help_message=${(P)help_variable_name}
  [[ ! -z ${help_message} ]] && echo_info ${help_message} || echo_err "Help message unavailable"
}

_check_arg(){
  _help $1 && return
  [[ "$#" -eq 1 ]] && echo_err "$1 is not set!"
}
