### kk ###
kk-server(){
[[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local port=7070
 echo_info "Starting python server on $port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server $port
}

kk-share(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local share_folder="Shared"
  if [[ ! -d "$share_folder" ]]; then cd && mkdir $share_folder; fi
  (cd ~/$share_folder && echo_ok "Running python server in $share_folder folder" && kk-server)
}
alias share='kk-share'

kk-upgrade(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 apt update && apt upgrade -y
 git -C $_SHELL_CONFIG_PATH pull
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

kk-ip(){
  ifconfig | grep 'inet addr'
}

kk-writeimageinstructions(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "image file"
  checkarg $2 "disk number"

  lsblk
  echo_info "umount /dev/$2X"
  echo_info "sudo dd if=$1 of=/dev/$2 bs=4M && sync"
  echo_info "i.e. sudo dd if=/home/dawidkotarba/Downloads/ubuntu-17.10-desktop-amd64.iso of=/dev/sdb bs=4M && sync"
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
  sudo docker inspect $container_name | grep '"IPAddress"' | tail -n1 | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"
}

### NAVIGATE ###
kk-navigaterepo(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  cd $_REPOSITORY_PATH
}
