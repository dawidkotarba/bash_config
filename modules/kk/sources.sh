### kk ###
kk-server(){
([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
 local port=$1
 [[ ! ${port} ]] && port=7070
 local hostname=`hostname`
 echo_info "Running python server: http://$hostname:$port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server ${port}
}

kk-share(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  local share_folder="Shared"
  if [[ ! -d "$share_folder" ]]; then cd && mkdir ${share_folder}; fi
  (cd ~/${share_folder} && kk-server)
}
alias share='kk-share'

kk-upgrade(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
 sudo apt update && sudo apt upgrade -y
 git -C ${_SHELL_CONFIG_PATH} pull
 _pull-cloned-apps
}

kk-bak(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
 checkarg $1 "Subject of backup"
 local date=`date | awk '{print $3"-"$2"-"$4}'`
 mv $1 $1_${date}
}
alias bak='kk-bak'

kk-killall(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "process name"
  local process_name=$1
  ps aux | grep ${process_name} | awk '{print $2}' | xargs kill
}

kk-fixpermissions(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  find . -type d | xargs chmod 755
  find . -type f | xargs chmod 644
}

kk-replaceinpath(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "old text"
  checkarg $2 "new text"
  find . -type f | xargs sed -i "s/$1/$2/g"
}

kk-findpath(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Folder name"
  local folder_name=$1
  find . -path "*/$folder_name"
}
alias findpath='kk-findpath'

kk-ip(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  ifconfig | grep 'inet addr'
}

kk-writeimageinstructions(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "image file"
  checkarg $2 "disk number"

  lsblk
  echo_info "umount /dev/$2X"
  echo_info "sudo dd if=$1 of=/dev/$2 bs=4M && sync"
  echo_info "i.e. sudo dd if=/home/dawidkotarba/Downloads/ubuntu-17.10-desktop-amd64.iso of=/dev/sdb bs=4M && sync"
}

kk-remountrw(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  mount -o remount,rw /
}

kk-ramdisk(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "size in GB"
  local size=$(($1 * 1024))
  local path="/mnt/ramdisk"
  sudo mkdir -p ${path}
  sudo mount -t tmpfs tmpfs ${path} -o size=${size}
}

kk-screenshot(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  gnome-screenshot -a -c
}

### DOCKER ###
kk-dockerstart(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "container name"
  local container_name=$1
  echo_info "Starting docker container: $1"
  sudo docker start ${container_name}
  kk-dockerip ${container_name}
}

kk-dockerip(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "container name"
  local container_name=$1
  sudo docker inspect ${container_name} | grep '"IPAddress"' | tail -n1 | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"
}

### NAVIGATE ###
kk-navigaterepo(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  cd ${_REPOSITORY_PATH}
}

kk-adduser(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "username"
  local username=$1
  sudo adduser ${username}
  sudo usermod -aG sudo ${username}
}
