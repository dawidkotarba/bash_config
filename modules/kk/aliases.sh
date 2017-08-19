### kk ###
kk-clipboard(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __check $1 "file path"
  cat $1 | xclip -selection clipboard
}
alias clip='kk-clipboard'

kk-server(){
[[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 local port=7070
 __echo_info "Starting python server on $port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server $port
}

### Aliases edition ###
kk-newfunction(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  kk-clipboard $BASH_NEW_FUNCTION_FILE
  __echo_ok "Function template copied to clipboard"
}

kk-newhelp(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  local help_code_line='[[ "$1" == "-h" ]] && __show_help $funcstack[1] && return'
  echo "$help_code_line" | xclip -selection clipboard
  __echo_ok "Help template copied to clipboard"
}

kk-newcheck(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  local check_code_line='__check $1 "paramName"'
  echo "$check_code_line" | xclip -selection clipboard
  __echo_ok "Check template copied to clipboard"
}

kk-bashnewmodule(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __check $1 "module_name"
 local module_name=$1
 local module_path=$BASH_MODULES_PATH/$module_name
 [[ ! -d $module_name ]] && mkdir $BASH_MODULES_PATH/$module_name
 echo "### help ###" >  $module_path/help.sh
 echo "### $module_name ###" > $module_path/aliases.sh
}

kk-bashedit(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 local module_name=$1
 if [[ $module_name ]]
   then
     atom $BASH_MODULES_PATH/$module_name/aliases.sh
     atom $BASH_MODULES_PATH/$module_name/help.sh
   else
     atom $BASH_ALIASES_PATH
     atom $BASH_CONFIG_PATH/help.sh
  fi
}

kk-bashedithelp(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 __check $1 "module_name"
 local module_name=$1
 [[ $module_name ]] && atom $BASH_MODULES_PATH/$module_name/help.sh
}

kk-bashshow(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 local module_name=$1
 [[ $module_name ]] && less $BASH_MODULES_PATH/$module_name/aliases.sh || less $BASH_ALIASES_PATH
}

kk-bashcommit(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 __git_add_commit_folder $BASH_CONFIG_PATH
}

kk-bashpush(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 git -C $BASH_CONFIG_PATH push
}

kk-bashcommitpush(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  kk-bashcommit
  kk-bashpush
}

kk-bashrevert(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  git -C $BASH_CONFIG_PATH checkout -f
}

__pull-cloned-apps(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 local apps=$(ls $BASH_APPS_PATH)
 for app in $apps
  do
  local app_path="$BASH_APPS_PATH/$app"
   git -C $app_path reset HEAD --hard
   git -C $app_path pull
  done
}

kk-upgrade(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 apt update && apt upgrade -y
 git -C $BASH_CONFIG_PATH pull
 __pull-cloned-apps
}

kk-bak(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __check $1 "Subject of backup"
 local date=`date | awk '{print $3"-"$2"-"$4}'`
 mv $1 $1_$date
}
alias bak='kk-bak'

kk-killall(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  local process_name=$1
  ps aux | grep $process_name | awk '{print $2}' | xargs kill
}

k(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __echo_ok "refreshing..."
  exec bash
}

### DOCKER ###
kk-dockerstart(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __check $1 "container name"
  local container_name=$1
  __echo_info "Starting docker container: $1"
  sudo docker start $container_name
  kk-dockerip $container_name
}

kk-dockerip(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  __check $1 "container name"
  local container_name=$1
  sudo docker inspect $container_name | grep '"IPAddress"' | tail -n1
}

### NAVIGATE ###
kk-navigate(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  cd $BASH_CONFIG_PATH
}

kk-navigaterepo(){
  [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
  cd $REPOSITORY_PATH
}

### SCALA ###
kk-createscala(){
 [[ "$1" == "-h" ]] && __show_help $funcstack[1] && return
 cp $BASH_SCRIPTS_PATH/scala_script.sh .
}
