printf "-> ["
########################
# Settings and aliases #
########################

# Default settings
HISTSIZE=99999
HISTFILESIZE=99999

### EXPORTS ###
export TERM='xterm-256color'
export VISUAL=vim

######################
## INITIAL SOURCING ##
######################
# source paths to main directories and help
_SHELL_CONFIG_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${_SHELL_CONFIG_PATH}/constants.sh
source ${_SHELL_CONFIG_PATH}/help.sh
source ${_SHELL_SHARED_PATH}/echo.sh
source ${_SHELL_SHARED_PATH}/checks.sh
source ${_SHELL_SHARED_PATH}/utils.sh

######################
## MODULES SOURCING ##
######################
_show_step_counter(){
 local color=`tput setaf 2`
 local reset=`tput sgr0`
 local dot="="
 printf "${color}${dot}${reset}"
}
_source_if_exists(){
 local file=$1
 if [[ -f ${file} ]]
  then
   source ${file}
   _show_step_counter
   echo_debug "--> Sourced $file"
  else
   echo_err "--> Cannot source $file"
 fi
}

_source_forward_declarations(){
  _help $1 && return
  _show_step_counter
  grep -rh "\w() *{" ${_SHELL_MODULES_PATH} | tr -d " " | xargs -I {} echo -e "{}\n:\n}" > ${_SHELL_FWD_FILEPATH}
  source ${_SHELL_FWD_FILEPATH}
}
echo_pretty "Sourcing forward declarations:"
_source_forward_declarations

_source_modules(){
  _help $1 && return
 _show_step_counter

 # source modules and help files except tmp
 for file in $(find ${_SHELL_MODULES_PATH} -type f -name help.sh | grep -v ${_OVERRIDE_MODULE_PATH}); do _source_if_exists "$file"; done
 for file in $(find ${_SHELL_MODULES_PATH} -type f -name sources.sh | grep -v ${_OVERRIDE_MODULE_PATH}); do _source_if_exists "$file"; done

 # source override module for overriding existing aliases/functions
 _source_if_exists ${_OVERRIDE_MODULE_PATH}/help.sh
 _source_if_exists ${_OVERRIDE_MODULE_PATH}/sources.sh
}
echo_pretty "Sourcing modules:"
_source_modules

### PATH AND AUTOSTART ###
echo_pretty "Sourcing path and autostart:"
_source_if_exists ${_SHELL_PATH_FILEPATH}
_source_if_exists ${_SHELL_AUTOSTART_FILEPATH}

### APPS ###
echo_pretty "Sourcing apps:"

# z -> https://github.com/rupa/z.git
_source_if_exists ${_SHELL_APPS_PATH}/z/z.sh

# liquidprompt -> https://github.com/nojhan/liquidprompt.git
[[ $- = *i* ]] && _source_if_exists ${_SHELL_APPS_PATH}/liquidprompt/liquidprompt

# zsh-syntax-highlighting -> https://github.com/zsh-users/zsh-syntax-highlighting
_source_if_exists ${_SHELL_APPS_PATH}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions -> https://github.com/zsh-users/zsh-autosuggestions
_source_if_exists ${_SHELL_APPS_PATH}/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# zsh settings
zstyle ':completion:*' special-dirs true

printf "]\n"
