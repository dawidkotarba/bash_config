### kk ###
kk-server(){
 local port=7070
 __echo_info "Starting python server on $port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server $port
}

kk-bashcreatemodule(){
  __help $1 "Creatse new module (modules/xxx/aliases)"
  __help $1 "Usage: kk-bashcreatemodule tst"

  __checkArgument $1 "module_name"

 local module_name=$1
 local module_path=$BASH_MODULES_PATH/$module_name

 if [[ ! -d $module_name ]]
  then mkdir $BASH_MODULES_PATH/$module_name
 fi
 echo "### $module_name ###" > $module_path/aliases
}

kk-bashedit(){
 __help $1 "Edits 'aliases' file from provided module."
 __help $1 "If no module is specified, then edits a main 'aliases' file."

 local module_name=$1

 if [[ $module_name ]]
  then atom $BASH_MODULES_PATH/$module_name/aliases
  else atom $BASH_ALIASES_PATH
 fi
}

kk-bashshow(){
  __help $1 "Shows 'aliases' file from provided module."
  __help $1 "If no module is specified, then shows a main 'aliases' file"

local module_name=$1
if [[ $module_name ]]
 then less $BASH_MODULES_PATH/$module_name/aliases
 else less $BASH_ALIASES_PATH
fi
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

kk-upgrade(){
  apt update && apt upgrade -y
}

kk-bak(){
  __help $1 "Renames a subject by adding current date."
  __checkArgument $1 "Subject of backup"

 local date=`date | awk '{print $3"-"$2"-"$4}'`
 mv $1 $1_$date
}
alias bak='kk-bak'

kk-killall(){
  local process_name=$1
  ps aux | grep $process_name | awk '{print $2}' | xargs kill
}
alias killall='kk-killall'

kk-notescommit(){
  __git_add_commit_folder $NOTES_PATH
}

k(){
  __echo_ok "refreshing..."
  exec bash
}

### DOCKER ###
kk-dockerstart(){
  __help $1 "Starts a docker container with provided name"
  __checkArgument $1 "container name"

  local container_name=$1
  __echo_info "Starting docker container: $1"
  sudo docker start $container_name
  kk-dockerip $container_name
}

kk-dockerip(){
  __help $1 "Prints ip of provided docker container"
  __checkArgument $1 "container name"

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