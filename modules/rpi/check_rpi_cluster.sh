#!/bin/bash

ping-host(){
 ping -c 1 $1 &> /dev/null && return 0 || return 1
}

ssmtp_send_email(){
 {
    echo To: $1
    echo Subject: $2 is unavailable!
    echo $2 is unavailable!
 } | ssmtp $1
}

email-if-unavailable(){
 local ip=$1
 local email_to=$2
 ping-host $ip

 if [[ $? -eq 1 ]]
  then
   echo "$msg"
   ssmtp_send_email $email_to $ip
   echo "email sent to $email_to"
  else
   echo "$ip is pingable"
 fi
}

email-if-unavailable $1 $2
