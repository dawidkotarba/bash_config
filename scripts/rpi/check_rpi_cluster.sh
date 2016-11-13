#!/bin/bash

DIR_PATH=$(dirname $0)
source $DIR_PATH/shared

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
