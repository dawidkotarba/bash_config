### SETTINGS ###

# LOG LVL: 0 - info, 1 - warn, 2 - error
LOG_LVL_DEBUG=0
LOG_LVL_INFO=1
LOG_LVL_WARN=2
LOG_LVL_ERROR=3

CURRENT_LOG_LVL=$LOG_LVL_INFO

### EXPORTS ###
export TERM='xterm-256color'

######################
## INITIAL SOURCING ##
######################
# source paths to main directories
__source_dirs(){
  BASH_CONFIG_PATH=~/bash_config
  source $BASH_CONFIG_PATH/dirs.sh
}
__source_dirs

# Each function included in modules/xxx/aliases will be forward declared
__source_forward_declarations(){
  grep -rh "() *{" $BASH_MODULES_PATH | tr -d " " | xargs -I [] echo -e "[]\n:\n}" > $BASH_FWD_PATH
  source $BASH_FWD_PATH
}
__source_forward_declarations

### ALIASES ###
alias ll='ls -alh'
alias l.='ls -d .*'
alias h='history'
alias j='jobs -l'
alias du='du -h'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# net aliases
alias ports='netstat -tulanp'
alias ping='ping -c 5'

# apps aliases
alias r='ranger'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias g='glances'
alias st='tig status'

### Functions ###
# decorated echo
__echo_pretty(){
 local text=$1
 [[ $CURRENT_LOG_LVL -le $LOG_LVL_DEBUG ]] && echo "### $text ###"
}

__echo_arrow(){
 local text=$1
 echo "--> $text"
}

# echo in white
__echo_debug(){
 [[ $CURRENT_LOG_LVL -le $LOG_LVL_DEBUG ]] && echo "$@"
}

# echo in blue
__echo_info(){
 local color=`tput setaf 4`
 local reset=`tput sgr0`
 [[ $CURRENT_LOG_LVL -le $LOG_LVL_INFO ]] && echo "${color}$@${reset}"
}

# echo in green
__echo_ok(){
 local color=`tput setaf 2`
 local reset=`tput sgr0`
 [[ $CURRENT_LOG_LVL -le $LOG_LVL_INFO ]] && echo "${color}$@${reset}"
}

# echo in yellow
__echo_warn(){
 local color=`tput setaf 11`
 local reset=`tput sgr0`
 [[ $CURRENT_LOG_LVL -le $LOG_LVL_WARN ]] && echo "${color}$@${reset}"
}

# echo in red
__echo_err(){
 local color=`tput setaf 1`
 local reset=`tput sgr0`
 [[ $CURRENT_LOG_LVL -le $LOG_LVL_ERROR ]] && echo "${color}$@${reset}"
}

# Prints error description when parameter is not set
# Usage: __checkArgument $1 paramName
__checkArgument(){
  [[ "$#" -eq 1 ]] && __echo_err "$1 is not set!"
}

# Prints help tip
# Usage: __help $1 "usage message"
__help(){
  [[ "$1" == "--help" ]] && __echo_info "$2"
}

# Adds a string to path, i.e.: __pathadd "/etc/scala/bin"
__pathadd() {
    if [ -d "$1" ] && ! echo $PATH | grep -E -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:${1%/}"
        else
            PATH="${1%/}:$PATH"
        fi
    fi
}

# Removes a string from path
__pathrm() {
    PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}

__source_if_exists(){
 local file=$1
 if [ -f $file ]
  then
   source $file
   __echo_debug "--> Sourced $file"
  else
   __echo_err "--> Cannot source $file"
 fi
}

__git_add_commit_folder(){
 local folder_name=$1
 git -C $folder_name commit -a -m "update"
}

__ssh_cert(){
 local username=$1
 local host=$2
 local cert_path=$3
 ssh -i $cert_path $username@$host
}

__scp_cert(){
 local username=$1
 local host=$2
 local cert_path=$3
 local path=$4
 scp -i $cert_path $username@$host:$path .
}

### OPENCONNECT VPN ###
__openconnect_vpn(){
 local user=$1
 local vpn_url=$2
 local params=$3
 sudo openconnect -u $user $vpn_url $params
}

__openconnect_vpn_kill_signal(){
  local signal=$1
  local pattern=$2
  local PS=`ps aux | grep "sudo openconnect" | grep $pattern | awk '{print $2}' | head -1`
  if [[ $PS ]]
   then
    __echo_ok "$signal for VPN: $pattern"
    sudo kill -$signal $PS
   else __echo_err "Not connected to VPN: $pattern"
  fi
}

######################
## MODULES SOURCING ##
######################

### SOURCE MODULES ###
__echo_pretty "Sourcing modules:"
__source_modules_aliases(){
 local aliases_files=`find $BASH_MODULES_PATH -type f -name aliases.sh`
 for i in $aliases_files
  do __source_if_exists $i
 done
}
__source_modules_aliases

### PATH AND AUTOSTART ###
__echo_pretty "Sourcing path and autostart:"
__source_if_exists $BASH_CONFIG_PATH/path.sh
__source_if_exists $BASH_CONFIG_PATH/autostart.sh

### APPS ###
__echo_pretty "Sourcing apps:"
# z -> https://github.com/rupa/z.git
__source_if_exists $BASH_APPS_PATH/z/z.sh

# liquidprompt -> https://github.com/nojhan/liquidprompt.git
[[ $- = *i* ]] && source $BASH_APPS_PATH/liquidprompt/liquidprompt

# the fuck -> https://github.com/nvbn/thefuck
eval "$(thefuck --alias f)"
