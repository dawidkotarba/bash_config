### util ###
util-server(){
([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
 local port=$1
 [[ ! ${port} ]] && port=7070
 local hostname=`hostname`
 echo_info "Running python server: http://$hostname:$port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server ${port}
}

util-share(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  local share_folder="Shared"
  if [[ ! -d "$share_folder" ]]; then cd && mkdir ${share_folder}; fi
  (cd ~/${share_folder} && util-server)
}
alias share='util-share'

util-upgrade(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
 sudo apt update && sudo apt upgrade -y
 git -C ${_SHELL_CONFIG_PATH} pull
 _pull-cloned-apps
}
alias upgrade='util-upgrade'

util-bak(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
 checkarg $1 "Subject of backup"
 local date=`date | awk '{print $2"-"$3"-"$5}'`
 mv $1 $1_${date}
}
alias bak='util-bak'

util-prefixallfiles(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "prefix must be set"
  local prefix=$1
  for f in * ; do mv -- "${f}" "${prefix}${f}" ; done
}

util-suffixallfiles(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "suffix must be set"
  local suffix=$1
  for f in * ; do mv -- "${f}" "${f}${suffix}" ; done
}

util-killall(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "process name"
  local process_name=$1
  ps aux | grep ${process_name} | awk '{print $2}' | xargs kill
}

util-fixpermissions(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  find . -type d | xargs chmod 755
  find . -type f | xargs chmod 644
}

util-replaceinpath(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "old text"
  checkarg $2 "new text"
  find . -type f | xargs sed -i "s/$1/$2/g"
}

util-findpath(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Folder name"
  local folder_name=$1
  find . -path "*/$folder_name"
}
alias findpath='util-findpath'

util-tar-compress(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Folder/file name"
  local folder=$1
  tar -zcvf ${folder}.tar.gz ${folder}
}
alias tar-compress='util-tar-compress'

util-tar-extract(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Folder/file name"
  local folder=$1
  tar -zxvf ${folder}
}
alias tar-extract='util-tar-extract'

util-ip(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  ifconfig | grep 'inet addr'
}

util-writeimageinstructions(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "image file"
  checkarg $2 "disk number"

  lsblk
  echo_info "umount /dev/$2X"
  echo_info "sudo dd if=$1 of=/dev/$2 bs=4M && sync"
  echo_info "i.e. sudo dd if=/home/dawidkotarba/Downloads/ubuntu-17.10-desktop-amd64.iso of=/dev/sdb bs=4M && sync"
}

util-remountrw(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  mount -o remount,rw /
}

util-ramdisk(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "size in GB"
  local size=$(($1 * 1024))
  local path="/mnt/ramdisk"
  sudo mkdir -p ${path}
  sudo mount -t tmpfs tmpfs ${path} -o size=${size}
}

util-screenshot(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  gnome-screenshot -a -c
}

### DOCKER ###
util-dockerstart(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "container name"
  local container_name=$1
  echo_info "Starting docker container: $1"
  sudo docker start ${container_name}
  util-dockerip ${container_name}
}

util-dockerip(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "container name"
  local container_name=$1
  sudo docker inspect ${container_name} | grep '"IPAddress"' | tail -n1 | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"
}

util-adduser(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "username"
  local username=$1
  sudo adduser ${username}
  sudo usermod -aG sudo ${username}
}
