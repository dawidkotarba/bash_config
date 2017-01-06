#! /bin/bash

LOG_DIR=~/logs

create-folder(){
 local destination=$1
 local destination_rights=$2

 if [ ! -d "$destination" ]; then
   echo "Folder $destination is not present. Creating a folder..."
   mkdir $destination
   chmod $destination_rights $destination
   echo "Folder created."
 fi
}

count-file-lines(){
 local filePath=$1
 return `cat $filePath | wc -l`
}

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
