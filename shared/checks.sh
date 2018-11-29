####################
# Helps and checks #
####################

# Constants:
HELP_SUFFIX=_help_

# Functions:
show_help(){
  checkarg $1 "Funciton name that is translated to related variable name"
  local help_variable_name=`echo "$HELP_SUFFIX$1" | tr - _`
  # local help_message=${!help_variable_name} # bash
  local help_message=${(P)help_variable_name}
  [[ ! -z ${help_message} ]] && echo_info ${help_message} || echo_err "Help message unavailable"
}

checkarg(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  [[ "$#" -eq 1 ]] && echo_err "$1 is not set!"
}
