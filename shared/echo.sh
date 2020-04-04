###########
## ECHOS ##
###########

# Constants:
# LOG LVL: 0 - info, 1 - warn, 2 - error
LOG_LVL_DEBUG=0
LOG_LVL_INFO=1
LOG_LVL_WARN=2
LOG_LVL_ERROR=3
CURRENT_LOG_LVL=1

# Functions:
echo_pretty(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && echo_info "decorated echo" && return
 local text=$1
 [[ ${CURRENT_LOG_LVL} -le ${LOG_LVL_DEBUG} ]] && echo "### $text ###"
}

echo_arrow(){
 local text=$1
 echo_info "==> $text"
}

echo_ok(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && echo_info "Echo in green" && return
 local color=`tput setaf 2`
 local reset=`tput sgr0`
 [[ ${CURRENT_LOG_LVL} -le ${LOG_LVL_INFO} ]] && echo "${color}$@${reset}"
}

echo_info(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && echo_info "Echo in blue" && return
  local color=`tput setaf 4`
  local reset=`tput sgr0`
  [[ ${CURRENT_LOG_LVL} -le ${LOG_LVL_INFO} ]] && echo "${color}$@${reset}"
}

echo_debug(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && echo_info "Echo in white" && return
 [[ ${CURRENT_LOG_LVL} -le ${LOG_LVL_DEBUG} ]] && echo "$@"
}

echo_warn(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && echo_info "Echo in yellow" && return
 local color=`tput setaf 11`
 local reset=`tput sgr0`
 [[ ${CURRENT_LOG_LVL} -le $LOG_LVL_WARN ]] && echo "${color}$@${reset}"
}

echo_err(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && echo_info "Echo in red" && return
 local color=`tput setaf 1`
 local reset=`tput sgr0`
 [[ ${CURRENT_LOG_LVL} -le $LOG_LVL_ERROR ]] && echo "${color}$@${reset}" >>/dev/stderr
}
