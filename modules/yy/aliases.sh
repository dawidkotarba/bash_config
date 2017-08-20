# HYBRIS
### consts ###
HYBRIS_LOG=y.log

### generic ###
_on_hybris_platform(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 rm -f $HYBRIS_LOG_PATH
 (cd $HYBRIS_HOME/bin/platform && $@ >> $HYBRIS_LOG_PATH &)
 sleep 1
 yy-log $@
}

_on_hybris_platform_nolog(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 (cd $HYBRIS_HOME/bin/platform && $@)
}

_on_hybris_process(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local result=`ps -aux | grep hybris`
 echo "Operating on Hybris processes: $result"
 echo $result | awk {'print $2'} | xargs $@
}

checkarg_hybris_suffix(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  [[ ! $HYBRIS_FOLDER_SUFFIX ]] && echo_err "HYBRIS SUFFIX NOT SET!"
}

_get_hybris_process(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  jcmd | grep tanukisoftware | awk {'print $1'}
}

_hybris-start(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _start-mysql-if-no-is_hsqldb
 _on_hybris_platform sh hybrisserver.sh debug $@
}

checkarg_hybris_mysql_running(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local is_mysql_running=$(yy-dockermysqlip)
    if [[ $is_mysql_running ]]
    then
      echo_ok "hybris MYSQL is running"
      export HYBRIS_MYSQL_RUNNING=true
    else
      echo_err "hybris MYSQL is NOT running"
      export HYBRIS_MYSQL_RUNNING=false
    fi
}

checkarg_and_start_hybris_mysql(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  [[ ! $HYBRIS_MYSQL_RUNNING ]] && yy-dockermysqlstart && checkarg_hybris_mysql_running
}

checkarg_if_hsqldb_is_used(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local entry_line=`grep "db.url=" $HYBRIS_LOCAL_PROPERTIES | grep -v "#.*db.url=" | tail -1 | grep hsqldb`
  [[ $entry_line ]] && echo 1 || echo 0
}

_start-mysql-if-no-is_hsqldb(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local is_hsqldb=`checkarg_if_hsqldb_is_used`
  [[ "$is_hsqldb" == 0 ]] && checkarg_and_start_hybris_mysql
}

_show_popup_if_hybris_has_started(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local started=`tail $HYBRIS_LOG_PATH | grep "INFO: Server startup in"`
  [[ $started ]] && _show_popup "$started"
}

### yy namespace ###
alias yy-start="_hybris-start"

yy-setsuffix(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "hybris suffix"
 export HYBRIS_FOLDER_SUFFIX=$1
 export HYBRIS_HOME=$REPOSITORY_PATH/hybris_$HYBRIS_FOLDER_SUFFIX/hybris
 export HYBRIS_LOG_PATH=$HYBRIS_HOME/$HYBRIS_LOG
 export HYBRIS_LOCAL_PROPERTIES=$HYBRIS_HOME/config/local.properties
}

yy-ps(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local hybris_process=`_get_hybris_process`
 [[ ! $hybris_process ]] && echo_err "HYBRIS IS NOT RUNNING" || echo_ok "HYBRIS IS RUNNING: $hybris_process"
}

yy-navigate(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cd $HYBRIS_HOME
}

yy-navigatecustom(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cd $HYBRIS_HOME/bin/custom
}

yy-navigateconfig(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cd $HYBRIS_HOME/config
}

yy-navigateplatform(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cd $HYBRIS_HOME/bin/platform
}

yy-log(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 [[ $@ != *'-nolog'* ]] && tail -f $HYBRIS_LOG_PATH
}

yy-logclean(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  > $HYBRIS_LOG_PATH
}

yy-grep(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  for var in "$@"
 do
  grep $var $HYBRIS_LOG_PATH
 done
}

yy-logerrorgrep(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 grep -E 'ERROR|WARN' $HYBRIS_LOG_PATH
}

yy-logerrortail(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  tail -f $HYBRIS_LOG_PATH | grep -E 'ERROR|WARN'
}

yy-logshow(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 less $HYBRIS_LOG_PATH
}

yy-logtomcat(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 (yy-navigate && cd log/tomcat && ls -lt | grep console | tail -1 | awk '{print $9}' | xargs tail -f)
}

yy-setantenv(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 (yy-navigateplatform && . ./setantenv.sh)
}

_yy-processes-to-kill(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 ps aux | grep hybris | grep -v $HYBRIS_LOG | grep -v atom | awk '{print $2}' | xargs kill
}

_yy-stop(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform sh hybrisserver.sh stop
}

yy-stop(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 echo_info "Before kill:"
 yy-ps
 local kill_executions=5
 for i in {1..$kill_executions}
 do
 _yy-processes-to-kill
 done
 echo_info "After kill ($kill_executions times):"
 yy-ps
 _yy-stop
}

yy-visualvm(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 jvisualvm --openpid `_get_hybris_process` &
}

yy-jcmd(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 jcmd `_get_hybris_process` help
}

yy-configlocalproperties(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 atom $HYBRIS_LOCAL_PROPERTIES
}

yy-configlocalextensions(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 atom $HYBRIS_HOME/config/localextensions.xml
}

yy-createproject(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "hybris project folder suffix"
  local hybris_folder_suffix=$1
  yy-setsuffix $hybris_folder_suffix
  echo yy-setsuffix $hybris_folder_suffix >> $SHELL_AUTOSTART_PATH
  mkdir $REPOSITORY_PATH/hybris_$hybris_folder_suffix
}

### HYBRIS ANT ###
yy-req(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "revision back"
 local rev_back=$1
 local changes_count=`git diff --name-only HEAD..HEAD~$rev_back | egrep '.impex|items.xml' | wc -l`
 [[ $changes_count > 0 ]] && echo "ant initialize" || echo "ant clean all"
}

yy-jrebel(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "extension path"
 local ext_path=$1
 [[ $ext_path ]] && (cd $ext_path && ant build)
}

yy-grunt(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "extension path"
  local ext_path=$1
  (cd $ext_path && grunt)
}

yy-antshow(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform ant -p
}

yy-antall(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform ant all $@
}

yy-antallstart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform_nolog ant all && yy-start
}

yy-antclean(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _on_hybris_platform ant clean
}

yy-antcleanall(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _on_hybris_platform ant clean all $@
}

yy-antcleanallstart(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform_nolog ant clean all && yy-start
}

yy-antbuild(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _on_hybris_platform ant build $@
}

yy-antupdatesystem(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _on_hybris_platform ant updatesystem $@
}

yy-antjunit(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _on_hybris_platform ant yunitinit
}

yy-antextgen(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cd $HYBRIS_HOME/bin/platform
 ant extgen
}

yy-antmodulegen(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cd $HYBRIS_HOME/bin/platform
 ant modulegen
}

yy-antinitialize(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _start-mysql-if-no-is_hsqldb
  _on_hybris_platform ant initialize $@
}

yy-antinitializestart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _start-mysql-if-no-is_hsqldb
  _on_hybris_platform_nolog ant initialize && yy-start
}

yy-anttest(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform ant clean all yunitinit alltests
}

yy-antserver(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _on_hybris_platform ant server
}

yy-copydbdriver(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg_hybris_suffix
 cp ~/APPS/Hybris/mysql/mysql-connector-java-5.1.35-bin.jar $HYBRIS_HOME/bin/platform/lib/dbdriver
}

_yy-get_mysql_container_name(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  echo mysql_$HYBRIS_FOLDER_SUFFIX
}

yy-dockermysqlstart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg_hybris_suffix
  kk-dockerstart $(_yy-get_mysql_container_name)
}

yy-dockermysqlip(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg_hybris_suffix
  kk-dockerip $(_yy-get_mysql_container_name)
}

yy-dockermysqlcreate(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg_hybris_suffix
  local mysql_version=""
  [[ $1 ]] && mysql_version=:$1
  sudo docker run --name $(_yy-get_mysql_container_name) -e MYSQL_ROOT_PASSWORD=root -d mysql/mysql-server$mysql_version --innodb_flush_log_at_trx_commit=0
}

yy-dockermysqlcreatedbuser(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  [[ "$1" == "-h" ]] && echo_info "yy-dockermysqlcreatedbuser dbName username userpassword" && return
  checkarg $1 "db name"
  checkarg $2 "user name"
  checkarg $3 "user password"

  local db_name=$1
  local user_name=$2
  local user_pwd=$3
  local root_pwd=root
  sudo docker exec -i $(_yy-get_mysql_container_name) mysql -uroot -p$root_pwd <<< "CREATE DATABASE $db_name"
  sudo docker exec -i $(_yy-get_mysql_container_name) mysql -uroot -p$root_pwd <<< "CREATE USER $user_name IDENTIFIED BY '$user_pwd'"
  sudo docker exec -i $(_yy-get_mysql_container_name) mysql -uroot -p$root_pwd <<< "GRANT ALL PRIVILEGES ON $db_name.* TO $user_name"
}
