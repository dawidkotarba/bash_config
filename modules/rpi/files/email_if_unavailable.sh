#!/bin/bash

ping-host(){
 ping -c 1 $1 &> /dev/null && return 0 || return 1
}

ssmtp_send_email(){
 local email_to=$1
 local ip=$2
 local hostname=`hostname`
 local date=`date`
 local msg="$ip is unavailable! Reporter: $hostname, $date"
 {
    echo To: $email_to
    echo Subject: $ip is unavailable!
    echo
    echo $msg
 } | /usr/sbin/ssmtp $email_to
}

email-if-unavailable(){
 local email_to=$1
 local ip=$2
 ping-host $ip

 if [[ $? -eq 1 ]]
  then
   echo "$ip is unavailable"
   ssmtp_send_email $email_to $ip
   echo "email sent to $email_to"
  else
   echo "$ip is available"
 fi
}

email-if-unavailable $1 $2
