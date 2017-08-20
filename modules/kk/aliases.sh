### kk ###
kk-clipboard(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "file path"
  cat $1 | xclip -selection clipboard
}
alias clip='kk-clipboard'

kk-server(){
[[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local port=7070
 echo_info "Starting python server on $port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server $port
}

_pull-cloned-apps(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local apps=$(ls $SHELL_APPS_PATH)
 for app in $apps
  do
  local app_path="$SHELL_APPS_PATH/$app"
   git -C $app_path reset HEAD --hard
   git -C $app_path pull
  done
}

kk-upgrade(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 apt update && apt upgrade -y
 git -C $SHELL_CONFIG_PATH pull
 _pull-cloned-apps
}

kk-bak(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Subject of backup"
 local date=`date | awk '{print $3"-"$2"-"$4}'`
 mv $1 $1_$date
}
alias bak='kk-bak'

kk-killall(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local process_name=$1
  ps aux | grep $process_name | awk '{print $2}' | xargs kill
}

kk-replaceinpath(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "old text"
  checkarg $2 "new text"
  find . -type f | xargs sed -i "s/$1/$2/g"
}

### DOCKER ###
kk-dockerstart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "container name"
  local container_name=$1
  echo_info "Starting docker container: $1"
  sudo docker start $container_name
  kk-dockerip $container_name
}

kk-dockerip(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "container name"
  local container_name=$1
  sudo docker inspect $container_name | grep '"IPAddress"' | tail -n1
}

### NAVIGATE ###
kk-navigaterepo(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  cd $REPOSITORY_PATH
}

### SCALA ###
kk-createscala(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 cp $SHELL_SCRIPTS_PATH/scala_script.sh .
}
