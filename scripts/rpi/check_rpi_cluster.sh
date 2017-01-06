#!/bin/bash

ping-host(){
 ping -c 1 $1 &> /dev/null && return 0 || return 1
}

ssmtp_send_email(){
 {
    echo To: $1
    echo Subject: $2
    echo
    $3
 } | ssmtp $1
}

email-if-unreachable(){
 local ip=$1
 local email_to=$2
 local msg="$ip is unreachable"
 ping-host $ip

 if [[ $? -eq 1 ]]
  then
   echo "$msg"
   ssmtp_send_email $email_to $msg
   echo "email sent to $email_to"
  else
   echo "$ip is reachable"
 fi
}

email-if-unreachable $1 $2
