####################
###### Utils #######
####################

# Popups and notifications
_show_popup(){
  _help $1 && return
  zenity --info --text "$1"
}

_show_notification(){
  _help $1 && return
  notify-send "$1"
}

# text utils
_trim() {
  _help $1 && return
  set -f
  set -- $*
  printf "%s\\n" "$*"
  set +f
}

_join(){
  _help $1 && return
  _check_arg $1 "delimiter"
  local IFS="$1"; shift; echo "$*";
}

_print_column(){
  _help $1 && return
  local delimiter=$1
  local column=$2
  tr -s "$delimiter" | cut -d "$delimiter" -f $column
}

# path utils
_pathadd() {
  _help $1 && return
    if [[ -d "$1" ]] && ! echo $PATH | grep -E -q "(^|:)$1($|:)" ; then
      [[ "$2" = "after" ]] && PATH="$PATH:${1%/}" || PATH="${1%/}:$PATH"
    fi
}

_pathrm() {
  _help $1 && return
  PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}

_get-desktop-path(){
  echo `xdg-user-dir DESKTOP`
}

_get-date(){
  date +%Y-%m-%d_%T
}

# app checks
_requires(){
  _help $1 && return
  for app in $@; do
    local app_present=`dpkg --list | grep -w $app | awk '{print $2}'`
    if [[ ! ${app_present} ]]
      then
        echo_err "Application [$app] is required but missing."
    fi
  done
}

# openconnect vpn
_openconnect_vpn(){
 _help $1 && return
 _check_arg $1 "user"
 _check_arg $2 "vpn url"
 local user=$1
 local vpn_url=$2
 local params=$3
 sudo openconnect -u ${user} ${vpn_url} ${params}
}

_openconnect_vpn_kill_signal(){
  _help $1 && return
  local signal=$1
  local pattern=$2
  local PS=`ps aux | grep "sudo openconnect" | grep $pattern | awk '{print $2}' | head -1`
  if [[ $PS ]]
   then
    echo_ok "$signal for VPN: $pattern"
    sudo kill -${signal} ${PS}
   else echo_err "Not connected to VPN: $pattern"
  fi
}

# certs
_ssh_cert(){
 _help $1 && return
 local username=$1
 local host=$2
 local cert_path=$3
 ssh -i ${cert_path} ${username}@${host}
}

_scp_cert(){
 _help $1 && return
 local username=$1
 local host=$2
 local cert_path=$3
 local path=$4
 scp -i ${cert_path} ${username}@${host}:${path} .
}
