### kk ###
kk-clipboard(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  __check $1 "file path"
  cat $1 | xclip -selection clipboard
}
alias clip='kk-clipboard'

kk-server(){
 local port=7070
 __echo_info "Starting python server on $port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server $port
}

### Aliases edition ###
kk-newfunction(){
  [[ "$1" == "-h" ]] && __echo_info "Copies function template to clipboard" && return
  kk-clipboard $BASH_NEW_FUNCTION_FILE
  __echo_ok "Function template copied to clipboard"
}

kk-newhelp(){
  local help_code_line='[[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return'
  echo "$help_code_line" | xclip -selection clipboard
  __echo_ok "Help template copied to clipboard"
}

kk-newcheck(){
  local check_code_line='__check $1 "paramName"'
  echo "$check_code_line" | xclip -selection clipboard
  __echo_ok "Check template copied to clipboard"
}

kk-bashnewmodule(){
 [[ "$1" == "-h" ]] && __echo_info "Creates a new module (modules/xxx/aliases.sh). Usage: kk-bashcreatemodule tst" && return
  __check $1 "module_name"
 local module_name=$1
 local module_path=$BASH_MODULES_PATH/$module_name
 [[ ! -d $module_name ]] && mkdir $BASH_MODULES_PATH/$module_name
 echo "### help ###" >  $module_path/help.sh
 echo "### $module_name ###" > $module_path/aliases.sh
}

kk-bashedit(){
 [[ "$1" == "-h" ]] && __echo_info "Edits 'aliases.sh' file from provided module. If no module is specified, then edits a main 'aliases.sh' file." && return

 local module_name=$1
 [[ $module_name ]] && atom $BASH_MODULES_PATH/$module_name/aliases.sh || atom $BASH_ALIASES_PATH
}

kk-bashshow(){
 [[ "$1" == "-h" ]] && __echo_info "Shows 'aliases.sh' file from provided module. If no module is specified, then shows a main 'aliases.sh' file" && return

 local module_name=$1
 [[ $module_name ]] && less $BASH_MODULES_PATH/$module_name/aliases.sh || less $BASH_ALIASES_PATH
}

kk-bashcommit(){
 __git_add_commit_folder $BASH_CONFIG_PATH
}

kk-bashpush(){
 git -C $BASH_CONFIG_PATH push
}

kk-bashcommitpush(){
  kk-bashcommit
  kk-bashpush
}

kk-bashrevert(){
  git -C $BASH_CONFIG_PATH checkout -f
}

__pull-cloned-apps(){
 [[ "$1" == "-h" ]] && __echo_info "Pulls all cloned apps in app folder." && return

 local apps=$(ls $BASH_APPS_PATH)
 for app in $apps
  do
  local app_path="$BASH_APPS_PATH/$app"
   git -C $app_path reset HEAD --hard
   git -C $app_path pull
  done
}

kk-upgrade(){
 apt update && apt upgrade -y
 git -C $BASH_CONFIG_PATH pull
 __pull-cloned-apps
}

kk-bak(){
  [[ "$1" == "-h" ]] && __echo_info "Renames a subject by adding current date." && return
  __check $1 "Subject of backup"

 local date=`date | awk '{print $3"-"$2"-"$4}'`
 mv $1 $1_$date
}
alias bak='kk-bak'

kk-killall(){
  local process_name=$1
  ps aux | grep $process_name | awk '{print $2}' | xargs kill
}

k(){
  __echo_ok "refreshing..."
  exec bash
}

### DOCKER ###
kk-dockerstart(){
  [[ "$1" == "-h" ]] && __echo_info "Starts a docker container with provided name" && return
  __check $1 "container name"

  local container_name=$1
  __echo_info "Starting docker container: $1"
  sudo docker start $container_name
  kk-dockerip $container_name
}

kk-dockerip(){
  [[ "$1" == "-h" ]] && __echo_info "Prints IP of provided docker container" && return
  __check $1 "container name"

  local container_name=$1
  sudo docker inspect $container_name | grep '"IPAddress"' | tail -n1
}

### NAVIGATE ###
kk-navigate(){
  cd $BASH_CONFIG_PATH
}

kk-navigaterepo(){
  cd $REPOSITORY_PATH
}

### SCALA ###
kk-createscala(){
 cp $BASH_SCRIPTS_PATH/scala_script.sh .
}
