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

uu-server(){
_help $1 && return
 local port=$1
 [[ ! ${port} ]] && port=7070
 local hostname=`hostname`
 echo_info "Running python server: http://$hostname:$port"
 #python -m SimpleHTTPServer $port
 python3 -m http.server ${port}
}
alias server="uu-server"

uu-share(){
  _help $1 && return
  local share_folder="Shared"
  if [[ ! -d "$share_folder" ]]; then cd && mkdir ${share_folder}; fi
  (cd ~/${share_folder} && uu-server)
}
alias share='uu-share'

uu-upgrade(){
 _help $1 && return
 sudo apt update && sudo apt upgrade -y
 git -C ${_SHELL_CONFIG_PATH} pull
 _pull-cloned-apps
}
alias upgrade='uu-upgrade'

uu-bak(){
 _help $1 && return
 _check_arg $1 "Subject of backup"
 local date=`date | awk '{print $2"-"$3"-"$5}'`
 mv $1 $1_${date}
}
alias bak='uu-bak'

uu-prefixallfiles(){
  _help $1 && return
  _check_arg $1 "prefix must be set"
  local prefix=$1
  for f in * ; do mv -- "${f}" "${prefix}${f}" ; done
}

uu-suffixallfiles(){
  _help $1 && return
  _check_arg $1 "suffix must be set"
  local suffix=$1
  for f in * ; do mv -- "${f}" "${f}${suffix}" ; done
}

uu-killall(){
  _help $1 && return
  _check_arg $1 "process name"
  local process_name=$1
  ps aux | grep ${process_name} | awk '{print $2}' | xargs kill
}

uu-fixpermissions(){
  _help $1 && return
  find . -type d | xargs chmod 755
  find . -type f | xargs chmod 644
}

uu-replaceinpath(){
  _help $1 && return
  _check_arg $1 "old text"
  _check_arg $2 "new text"
  find . -type f | xargs sed -i "s/$1/$2/g"
}

uu-findpath(){
  _help $1 && return
  _check_arg $1 "Folder name"
  local folder_name=$1
  find . -path "*/$folder_name"
}
alias findpath='uu-findpath'

uu-tarball(){
  _help $1 && return
  _check_arg $1 "Folder/file name"
  local folder=$1
  tar -zcvf ${folder}.tar.gz ${folder}
}
alias tarball='uu-tarball'

uu-untarball(){
  _help $1 && return
  _check_arg $1 "Folder/file name"
  local folder=$1
  tar -zxvf ${folder}
}
alias untarball='uu-untarball'

uu-ip(){
  _help $1 && return
  ifconfig | grep 'inet addr'
}

uu-writeimageinstructions(){
  _help $1 && return
  _check_arg $1 "image file"
  _check_arg $2 "disk number"

  lsblk
  echo_info "umount /dev/$2X"
  echo_info "sudo dd if=$1 of=/dev/$2 bs=4M && sync"
  echo_info "i.e. sudo dd if=/home/dawidkotarba/Downloads/ubuntu-17.10-desktop-amd64.iso of=/dev/sdb bs=4M && sync"
}

uu-remountrw(){
  _help $1 && return
  mount -o remount,rw /
}

uu-ramdisk(){
  _help $1 && return
  _check_arg $1 "size in GB"
  local size=$(($1 * 1024))
  local path="/mnt/ramdisk"
  sudo mkdir -p ${path}
  sudo mount -t tmpfs tmpfs ${path} -o size=${size}
}

uu-screenshot(){
  _help $1 && return
  gnome-screenshot -a -c
}

uu-checksum(){
  _help $1 && return
  _check_arg $1 "filename"
  echo "cksum: `cksum $1`"
  echo "md5sum: `md5sum $1`"
  echo "sha224sum: `sha224sum $1`"
  echo "sha256sum: `sha256sum $1`"
  echo "sha384sum: `sha384sum $1`"
  echo "sha512sum: `sha512sum $1`"
}
alias checksum='uu-checksum'

uu-adduser(){
  _help $1 && return
  _check_arg $1 "username"
  local username=$1
  sudo adduser ${username}
  sudo usermod -aG sudo ${username}
}

uu-copydate(){
  _help $1 && return
  echo `date +%F` | xclip -sel clip
}
alias checksum='uu-copydate'

uu-syslog(){
  _help $1 && return
  _requires lnav
  lnav /var/log/syslog
}
alias syslog='uu-syslog'

uu-suspend(){
  _help $1 && return
  systemctl suspend
}
alias cu='uu-suspend'

uu-onyx(){
  _help $1 && return
  _check_arg $1 "host number"
  _requires google-chrome
  nohup google-chrome http://192.168.0.$1:8083/ &
}
alias onyx='uu-onyx'

### DOCKER ###
uu-dockerstart(){
  _help $1 && return
  _check_arg $1 "container name"
  local container_name=$1
  echo_info "Starting docker container: $1"
  sudo docker start ${container_name}
  uu-dockerip ${container_name}
}

uu-dockerip(){
  _help $1 && return
  _check_arg $1 "container name"
  local container_name=$1
  sudo docker inspect ${container_name} | grep '"IPAddress"' | tail -n1 | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"
}

### GPG
gpg-encrypt(){
  _help $1 && return
  _check_arg $1 "email"
  _check_arg $2 "file name"
  local email=$1
  local file_name=$2
  gpg2 --card-status
  gpg2 --encrypt --recipient ${email} --output ${file_name}.gpg ${file_name}
}

gpg-decrypt(){
  _help $1 && return
  _check_arg $1 "file name"
  local file_name=$1
  gpg2 --card-status
  gpg2 --decrypt --output ${file_name}_decrypted ${file_name}
}
