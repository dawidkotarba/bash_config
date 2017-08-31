### RPI ###

pssh(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 parallel-ssh -h $__SHELL_MODULES_PATH/rpi/pssh_hosts -t -1 -l pi -A $@
}

rpi-clusterupgrade(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 pssh sudo apt update && apt upgrade
}

rpi-clusterinstall(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "application name[s]"
  pssh sudo apt install $@ -y
}

rpi-wifiscan(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 sudo iwlist wlan0 scan
}

rpi-wifiadd(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "ssid"
  checkarg $2 "password"
  wpa_passphrase $1 $2 >> /etc/wpa_supplicant/wpa_supplicant.conf
}
