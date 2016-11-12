#! /bin/bash

source $(dirname $0)/shared
LOG_DIR=/logs

write-temp(){
 local fileName=$LOG_DIR/temp.log

 echo "Writing temperature to file..."
 count-file-lines $fileName
 local currentEntries=$?

 if [ $currentEntries -gt 100 ];
  then get-temp > $fileName
  else get-temp >> $fileName
 fi
}

get-temp() {
 echo `date`:`/opt/vc/bin/vcgencmd measure_temp`
}

create-folder $LOG_DIR 755
write-temp
