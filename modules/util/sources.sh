### util ###

function repeat(){
 _help $1 && return
 _check_arg $1 "repeat time must be set"
 local i max
 max=$1; shift;
 for ((i=1; i <= max ; i++)); do
  eval "$@";
 done
}

util-server(){
_help $1 && return
 local port=$1
 [[ ! ${port} ]] && port=7070
 local hostname=`hostname`
 echo_info "Running python server: http://$hostname:$port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server ${port}
}
alias server="util-server"

util-share(){
  _help $1 && return
  local share_folder="Shared"
  if [[ ! -d "$share_folder" ]]; then cd && mkdir ${share_folder}; fi
  (cd ~/${share_folder} && util-server)
}
alias share='util-share'

util-upgrade(){
 _help $1 && return
 sudo apt update && sudo apt upgrade -y
 git -C ${_SHELL_CONFIG_PATH} pull
 _pull-cloned-apps
}
alias upgrade='util-upgrade'

util-bak(){
 _help $1 && return
 _check_arg $1 "Subject of backup"
 local date=`date | awk '{print $2"-"$3"-"$5}'`
 mv $1 $1_${date}
}
alias bak='util-bak'

util-prefixallfiles(){
  _help $1 && return
  _check_arg $1 "prefix must be set"
  local prefix=$1
  for f in * ; do mv -- "${f}" "${prefix}${f}" ; done
}

util-suffixallfiles(){
  _help $1 && return
  _check_arg $1 "suffix must be set"
  local suffix=$1
  for f in * ; do mv -- "${f}" "${f}${suffix}" ; done
}

util-killall(){
  _help $1 && return
  _check_arg $1 "process name"
  local process_name=$1
  ps aux | grep ${process_name} | awk '{print $2}' | xargs kill
}

util-fixpermissions(){
  _help $1 && return
  find . -type d | xargs chmod 755
  find . -type f | xargs chmod 644
}

util-replaceinpath(){
  _help $1 && return
  _check_arg $1 "old text"
  _check_arg $2 "new text"
  find . -type f | xargs sed -i "s/$1/$2/g"
}

util-findpath(){
  _help $1 && return
  _check_arg $1 "Folder name"
  local folder_name=$1
  find . -path "*/$folder_name"
}
alias findpath='util-findpath'

util-tar-compress(){
  _help $1 && return
  _check_arg $1 "Folder/file name"
  local folder=$1
  tar -zcvf ${folder}.tar.gz ${folder}
}
alias tar-compress='util-tar-compress'

util-tar-extract(){
  _help $1 && return
  _check_arg $1 "Folder/file name"
  local folder=$1
  tar -zxvf ${folder}
}
alias tar-extract='util-tar-extract'

util-ip(){
  _help $1 && return
  ifconfig | grep 'inet addr'
}

util-writeimageinstructions(){
  _help $1 && return
  _check_arg $1 "image file"
  _check_arg $2 "disk number"

  lsblk
  echo_info "umount /dev/$2X"
  echo_info "sudo dd if=$1 of=/dev/$2 bs=4M && sync"
  echo_info "i.e. sudo dd if=/home/dawidkotarba/Downloads/ubuntu-17.10-desktop-amd64.iso of=/dev/sdb bs=4M && sync"
}

util-remountrw(){
  _help $1 && return
  mount -o remount,rw /
}

util-ramdisk(){
  _help $1 && return
  _check_arg $1 "size in GB"
  local size=$(($1 * 1024))
  local path="/mnt/ramdisk"
  sudo mkdir -p ${path}
  sudo mount -t tmpfs tmpfs ${path} -o size=${size}
}

util-screenshot(){
  _help $1 && return
  gnome-screenshot -a -c
}

util-checksum(){
  _help $1 && return
  _check_arg $1 "filename"
  echo "cksum: `cksum $1`"
  echo "md5sum: `md5sum $1`"
  echo "sha224sum: `sha224sum $1`"
  echo "sha256sum: `sha256sum $1`"
  echo "sha384sum: `sha384sum $1`"
  echo "sha512sum: `sha512sum $1`"
}
alias checksum='util-checksum'

### DOCKER ###
util-dockerstart(){
  _help $1 && return
  _check_arg $1 "container name"
  local container_name=$1
  echo_info "Starting docker container: $1"
  sudo docker start ${container_name}
  util-dockerip ${container_name}
}

util-dockerip(){
  _help $1 && return
  _check_arg $1 "container name"
  local container_name=$1
  sudo docker inspect ${container_name} | grep '"IPAddress"' | tail -n1 | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"
}

util-adduser(){
  _help $1 && return
  _check_arg $1 "username"
  local username=$1
  sudo adduser ${username}
  sudo usermod -aG sudo ${username}
}
