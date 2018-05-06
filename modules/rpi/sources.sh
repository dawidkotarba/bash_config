### RPI ###

_RPI_HOSTS=$_SHELL_MODULES_PATH/rpi/files/pssh_hosts
_RPI_NAMES=$_SHELL_MODULES_PATH/rpi/files/hosts_names
source $_RPI_NAMES

pssh(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 parallel-ssh -h $_RPI_HOSTS -t -1 -l pi -A $@
}

rpi-clusterupgrade(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 pssh sudo apt update && apt upgrade
}

rpi-clusterinstall(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  checkarg $1 "application name[s]"
  pssh sudo apt install $@ -y
}

rpi-wifiscan(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 sudo iwlist wlan0 scan
}

rpi-wifiadd(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  checkarg $1 "ssid"
  checkarg $2 "password"
  wpa_passphrase $1 $2 >> /etc/wpa_supplicant/wpa_supplicant.conf
}

rpi-ping(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  while read ip; do
   ping -c2 $ip
  done <$_RPI_HOSTS
}

rpi-wget(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 checkarg $1 "URL"
 wget -bcq $1
}
