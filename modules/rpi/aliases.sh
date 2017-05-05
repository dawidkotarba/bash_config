### RPI ###

pssh(){
 parallel-ssh -h $BASH_MODULES_PATH/rpi/pssh_hosts -t -1 -l pi -A $@
}

rpi-cluster-upgrade(){
 pssh sudo apt update && apt upgrade
}
