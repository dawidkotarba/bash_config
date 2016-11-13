#! /bin/bash

source $(dirname $0)/shared
LOG_DIR=/logs

write-temp(){
 local file_name=$LOG_DIR/temp.log

 echo "Writing temperature to file..."
 count-file-lines $file_name
 local currentEntries=$?

 if [ $currentEntries -gt 100 ];
  then get-temp > $file_name
  else get-temp >> $file_name
 fi
}

get-temp() {
 echo `date`:`/opt/vc/bin/vcgencmd measure_temp`
}

create-folder $LOG_DIR 755
write-temp
