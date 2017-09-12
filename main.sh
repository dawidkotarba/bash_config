######################
#Settings and aliases#
######################

# Default settings
HISTSIZE=99999
HISTFILESIZE=99999

### EXPORTS ###
export TERM='xterm-256color'

### ALIASES ###
alias ll='ls -alh'
alias l.='ls -d .*'
alias ll.='ls -lhd .*'
alias du='du -h'

# net aliases
alias ports='netstat -tulanp'
alias ping='ping -c 5'

######################
## INITIAL SOURCING ##
######################
# source paths to main directories and help
MAIN_PATH=~/shell_config
source $MAIN_PATH/constants.sh
source $MAIN_PATH/help.sh
source $_SHELL_SHARED_PATH/echo.sh
source $_SHELL_SHARED_PATH/checks.sh

######################
##  MAIN FUNCTIONS  ##
######################

### Other functions ###
_show_popup(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  zenity --info --text "$1"
}

_show_notification(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  notify-send "$1"
}

_pathadd() {
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
    if [[ -d "$1" ]] && ! echo $PATH | grep -E -q "(^|:)$1($|:)" ; then
      [[ "$2" = "after" ]] && PATH="$PATH:${1%/}" || PATH="${1%/}:$PATH"
    fi
}

_pathrm() {
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}

_source_if_exists(){
 local file=$1
 if [[ -f $file ]]
  then
   source $file
   echo_debug "--> Sourced $file"
  else
   echo_err "--> Cannot source $file"
 fi
}

_join(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "delimiter"
  local IFS="$1"; shift; echo "$*";
}

_ssh_cert(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local username=$1
 local host=$2
 local cert_path=$3
 ssh -i $cert_path $username@$host
}

_scp_cert(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local username=$1
 local host=$2
 local cert_path=$3
 local path=$4
 scp -i $cert_path $username@$host:$path .
}

_print_column(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local delimiter=$1
  local column=$2
  tr -s "$delimiter" | cut -d "$delimiter" -f $column
}

### OPENCONNECT VPN ###
_openconnect_vpn(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local user=$1
 local vpn_url=$2
 local params=$3
 sudo openconnect -u $user $vpn_url $params
}

_openconnect_vpn_kill_signal(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local signal=$1
  local pattern=$2
  local PS=`ps aux | grep "sudo openconnect" | grep $pattern | awk '{print $2}' | head -1`
  if [[ $PS ]]
   then
    echo_ok "$signal for VPN: $pattern"
    sudo kill -$signal $PS
   else echo_err "Not connected to VPN: $pattern"
  fi
}

######################
## MODULES SOURCING ##
######################
_source_forward_declarations(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  grep -rh "\w() *{" $_SHELL_MODULES_PATH | tr -d " " | xargs -I {} echo -e "{}\n:\n}" > $_SHELL_FWD_FILEPATH
  source $_SHELL_FWD_FILEPATH
}
echo_pretty "Sourcing forward declarations:"
_source_forward_declarations

_source_modules_aliases(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 for file in $(find $_SHELL_MODULES_PATH -type f -name help.sh); do _source_if_exists "$file"; done
 for file in $(find $_SHELL_MODULES_PATH -type f -name aliases.sh); do _source_if_exists "$file"; done
}
echo_pretty "Sourcing modules:"
_source_modules_aliases

### PATH AND AUTOSTART ###
echo_pretty "Sourcing path and autostart:"
_source_if_exists $_SHELL_PATH_FILEPATH
_source_if_exists $_SHELL_AUTOSTART_FILEPATH

### APPS ###
echo_pretty "Sourcing apps:"
# z -> https://github.com/rupa/z.git
_source_if_exists $_SHELL_APPS_PATH/z/z.sh

# liquidprompt -> https://github.com/nojhan/liquidprompt.git
[[ $- = *i* ]] && _source_if_exists $_SHELL_APPS_PATH/liquidprompt/liquidprompt

# zsh-syntax-highlighting
_source_if_exists /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
_source_if_exists $_SHELL_APPS_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
