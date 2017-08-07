### RPI ###

pssh(){
 parallel-ssh -h $BASH_MODULES_PATH/rpi/pssh_hosts -t -1 -l pi -A $@
}

rpi-cluster-upgrade(){
 pssh sudo apt update && apt upgrade
}

rpi-wifiscan(){
  sudo iwlist wlan0 scan
}

rpi-wifiadd(){
  [[ "$1" == "-h" ]] && __echo_info "Saves wifi ssid/password. Usage: rpi-wifiadd testingssid testingpassword" && return
  __check $1 "ssid"
  __check $2 "password"
  wpa_passphrase $1 $2 >> /etc/wpa_supplicant/wpa_supplicant.conf
}
