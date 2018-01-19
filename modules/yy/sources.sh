# HYBRIS
### consts ###
_HYBRIS_LOG=log/y.log

### generic ###
_on_hybris_platform(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 rm -f $_HYBRIS_LOG_PATH
 (cd $_HYBRIS_HOME/bin/platform && $@ >> $_HYBRIS_LOG_PATH &)
 sleep 1
 _show_notification_if_hybris_started &
 yy-log $@
}

_ant_on_hybris_platform(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _show_notification_if_hybris_started &
 (cd $_HYBRIS_HOME/bin/platform && ant $@)
}

_on_hybris_platform_nolog(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _show_notification_if_hybris_started &
 (cd $_HYBRIS_HOME/bin/platform && $@)
}

_on_hybris_installer(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  (cd $_HYBRIS_HOME/../installer && ./install.sh $@)
}

_on_hybris_process(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local result=`ps -aux | grep hybris`
 echo "Operating on Hybris processes: $result"
 echo $result | awk {'print $2'} | xargs $@
}

_check_hybris_suffix(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  [[ ! $_HYBRIS_FOLDER_SUFFIX ]] && echo_err "HYBRIS SUFFIX NOT SET!"
}

_get_hybris_process(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  pgrep -f tanukisoftware
}

_show_notification_if_hybris_started(){
  [[ ! -f $_HYBRIS_LOG_PATH ]] && echo_err "Cannot find $_HYBRIS_LOG" && return
  local is_process_running_in_background=`jobs | grep _show_notification_if_hybris_started`
  if [[ -z $is_process_running_in_background ]]
   then
     local started=""
     while [[ -z $(tail $_HYBRIS_LOG_PATH | grep 'Server startup in') ]]; do sleep 1; done
     local startup_line=$(tail $_HYBRIS_LOG_PATH | grep 'Server startup in')
     local bean_creation_error=`_get_context_creation_error`
     _show_notification "$startup_line $bean_creation_error"
  fi
}

_get_context_creation_error(){
  echo `cat $_HYBRIS_LOG_PATH | grep "Error creating bean with name" | head -n1`
}

_is_hybris_mysql_running(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local is_mysql_running=$(yy-dockermysqlip)
    if [[ $is_mysql_running ]]
    then
      echo_ok "hybris MYSQL is running"
      _HYBRIS_MYSQL_RUNNING=true
    else
      echo_err "hybris MYSQL is NOT running"
      _HYBRIS_MYSQL_RUNNING=false
    fi
}

_start_hybris_mysql(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  [[ ! $_HYBRIS_MYSQL_RUNNING ]] && yy-dockermysqlstart && _is_hybris_mysql_running
}

_is_hsqldb_used(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local entry_line=`grep "db.url=" $_HYBRIS_LOCAL_PROPERTIES | grep -v "#.*db.url=" | tail -1 | grep hsqldb`
  [[ $entry_line ]] && echo 1 || echo 0
}

_start_mysql_if_used(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local is_hsqldb=`_is_hsqldb_used`
  [[ "$is_hsqldb" == 0 ]] && _start_hybris_mysql
}

_get_mysql_container_name(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  echo mysql_$_HYBRIS_FOLDER_SUFFIX
}

_kill_hybris_processes(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 ps aux | grep hybris | grep -v $_HYBRIS_LOG | grep -v vim | awk '{print $2}' | xargs kill
}

_stop_hybris_server(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform sh hybrisserver.sh stop
}

### yy namespace ###
yy-setsuffix(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "hybris suffix"
 _HYBRIS_FOLDER_SUFFIX=$1
 _HYBRIS_HOME=$_REPOSITORY_PATH/hybris_$_HYBRIS_FOLDER_SUFFIX/hybris
 _HYBRIS_LOG_PATH=$_HYBRIS_HOME/$_HYBRIS_LOG
 _HYBRIS_CONFIG_PATH=$_HYBRIS_HOME/config
 _HYBRIS_LOCAL_PROPERTIES=$_HYBRIS_CONFIG_PATH/local.properties
 _HYBRIS_CUSTOM_PROPERTIES=$_HYBRIS_CONFIG_PATH/custom.properties
}

yy-ps(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local hybris_process=`_get_hybris_process`
 if [[ ! $hybris_process ]]
  then echo_warn "Hybris is not running"
 else
  local run_time=`ps -o etime= -p $hybris_process | xargs echo -n`
  echo_ok "Hybris is running: pid: $hybris_process, time: $run_time"
 fi
}

yy-navigate(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cd $_HYBRIS_HOME
}

yy-navigatecustom(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cd $_HYBRIS_HOME/bin/custom
}

yy-navigateconfig(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cd $_HYBRIS_CONFIG_PATH
}

yy-navigateplatform(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cd $_HYBRIS_HOME/bin/platform
}

yy-navigateinstaller(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _check_hybris_suffix
  cd $_HYBRIS_HOME/../installer
}

yy-installb2b(){
  _on_hybris_installer -r b2b_acc setup
  _on_hybris_installer -r b2b_acc initialize
}

yy-log(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 [[ $@ != *'-nolog'* ]] && less +F $_HYBRIS_LOG_PATH
}

yy-logclean(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  > $_HYBRIS_LOG_PATH
}

yy-grep(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  for var in "$@"
 do
  grep $var $_HYBRIS_LOG_PATH
 done
}

yy-logerrorgrep(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 grep -E 'ERROR|WARN' $_HYBRIS_LOG_PATH
}

yy-logerrortail(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  less +F $_HYBRIS_LOG_PATH | grep -E 'ERROR|WARN'
}

yy-logless(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 less $_HYBRIS_LOG_PATH
}

yy-logvim(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 vim $_HYBRIS_LOG_PATH
}

yy-logcat(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 cat $_HYBRIS_LOG_PATH
}

yy-logtomcat(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 (yy-navigate && cd log/tomcat && ls -lt | grep console | tail -1 | awk '{print $9}' | xargs less +F)
}

yy-setantenv(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 (yy-navigateplatform && . ./setantenv.sh)
}

yy-start(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _start_mysql_if_used
 _on_hybris_platform sh hybrisserver.sh debug $@
}

yy-stop(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 echo_info "Before kill:"
 yy-ps
 local kill_executions=5
 for i in {1..$kill_executions}
 do
 _kill_hybris_processes
 done
 echo_info "After kill ($kill_executions times):"
 yy-ps
 _stop_hybris_server
}

yy-jvisualvm(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 jvisualvm --openpid `_get_hybris_process` &
}

yy-jcmd(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 jcmd `_get_hybris_process` help
}

yy-checkcontext(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local bean_creation_error=`_get_context_creation_error`
  [[ -z $bean_creation_error ]] && echo_ok "OK" || echo_err "$bean_creation_error"
}

yy-configlocalproperties(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 vim $_HYBRIS_LOCAL_PROPERTIES
}

yy-configcustomproperties(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 vim $_HYBRIS_CUSTOM_PROPERTIES
}

yy-configlocalextensions(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 vim $_HYBRIS_CONFIG_PATH/localextensions.xml
}

yy-configcreatecustomproperties(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 if [[ ! -f $_HYBRIS_CUSTOM_PROPERTIES ]]
   then
    touch $_HYBRIS_CUSTOM_PROPERTIES
    echo_info "custom.properties created"
  else
    echo_warn "custom.properties file already exists"
 fi
}

yy-configcopycustomproperties(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 if [[ ! -f $_HYBRIS_CUSTOM_PROPERTIES ]]
   then
    cp $_SHELL_MODULES_PATH/yy/files/custom.properties $_HYBRIS_CONFIG_PATH
    echo_info "custom.properties copied"
  else
    echo_warn "custom.properties file already exists"
 fi
}

yy-configmergecustomproperties(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 if [[ -f $_HYBRIS_CUSTOM_PROPERTIES ]]
    then
      cat $_HYBRIS_CUSTOM_PROPERTIES >> $_HYBRIS_LOCAL_PROPERTIES
      echo_info "Properties merged"
      yy-antserver
    else
      echo_err "custom.properties file does not exist"
  fi
}

yy-createproject(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "hybris project folder suffix"
  local _HYBRIS_FOLDER_SUFFIX=$1
  yy-setsuffix $_HYBRIS_FOLDER_SUFFIX
  echo yy-setsuffix $_HYBRIS_FOLDER_SUFFIX >> $_SHELL_AUTOSTART_FILEPATH
  mkdir $_REPOSITORY_PATH/hybris_$_HYBRIS_FOLDER_SUFFIX
}

### HYBRIS ANT ###
yy-req(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "revision back"
 local rev_back=$1
 local changes_count=`git diff --name-only HEAD..HEAD~$rev_back | egrep '.impex|items.xml' | wc -l`
 [[ $changes_count > 0 ]] && echo "ant initialize" || echo "ant clean all"
}

yy-buildext(){
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

### ant tasks ###
yy-antshowtasks(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _ant_on_hybris_platform -p
}

yy-antall(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _ant_on_hybris_platform all $@
}

yy-antallstart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform_nolog ant all && yy-start
}

yy-antclean(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _ant_on_hybris_platform clean
}

yy-antcleanall(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _ant_on_hybris_platform clean all $@
}

yy-antcleanallstart(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _on_hybris_platform_nolog ant clean all && yy-start
}

yy-antbuild(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _ant_on_hybris_platform build $@
}

yy-antupdatesystem(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _ant_on_hybris_platform updatesystem $@
}

yy-antjunit(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _ant_on_hybris_platform yunitinit
}

yy-antextgen(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cd $_HYBRIS_HOME/bin/platform
 ant extgen
}

yy-antmodulegen(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cd $_HYBRIS_HOME/bin/platform
 ant modulegen
}

yy-antinitialize(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _start_mysql_if_used
  _ant_on_hybris_platform initialize $@
}

yy-antinitializestart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _start_mysql_if_used
  _on_hybris_platform_nolog ant initialize && yy-start
}

yy-anttest(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _ant_on_hybris_platform clean all yunitinit alltests
}

yy-antserver(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _ant_on_hybris_platform server
}

yy-antkill(){
  ps aux | grep ant | grep -v supplicant | _print_column " " 2 | xargs kill
}

yy-copydbdriver(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _check_hybris_suffix
 cp ~/APPS/Hybris/mysql/mysql-connector-java-5.1.35-bin.jar $_HYBRIS_HOME/bin/platform/lib/dbdriver
}

yy-dockermysqlstart(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _check_hybris_suffix
  kk-dockerstart $(_get_mysql_container_name)
}

yy-dockermysqlip(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _check_hybris_suffix
  kk-dockerip $(_get_mysql_container_name)
}

yy-dockermysqlcreate(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _check_hybris_suffix
  local mysql_version=""
  [[ $1 ]] && mysql_version=:$1
  sudo docker run --name $(_get_mysql_container_name) -e MYSQL_ROOT_PASSWORD=root -d mysql/mysql-server$mysql_version --innodb_flush_log_at_trx_commit=0
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
  sudo docker exec -i $(_get_mysql_container_name) mysql -uroot -p$root_pwd <<< "CREATE DATABASE $db_name"
  sudo docker exec -i $(_get_mysql_container_name) mysql -uroot -p$root_pwd <<< "CREATE USER $user_name IDENTIFIED BY '$user_pwd'"
  sudo docker exec -i $(_get_mysql_container_name) mysql -uroot -p$root_pwd <<< "GRANT ALL PRIVILEGES ON $db_name.* TO $user_name"
}

_get_tld_jars() {
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _check_hybris_suffix
  checkarg $1 "0 - get jars without TLD, 1 - with TLD"
  for f in $(find $_HYBRIS_HOME -name "*.jar"); do
    if [[ $(unzip -v ${f} | grep '.tld$' | wc -l) -eq $1 ]]; then
      echo "$(basename $f)"
    fi
  done
}

yy-tldjars(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _get_tld_jars 1
}

yy-tldjarswithout(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  _get_tld_jars 0
}

### HYBRIS GROOVY SCRIPTING CONSOLE ###
_copygroovyfile(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "filename"
  local filepath="$(_getmodulefilespath yy)/groovy/$1"
  clip "$filepath"
  echo_info "Copied: $filepath. Content:"
  cat $filepath
}

yy-groovyconsole-showfiles(){
  _copygroovyfile "showFiles.groovy"
}

yy-groovyconsole-showtomcatlogs(){
 _copygroovyfile "showTomcatLogs.groovy"
}

yy-groovyconsole-printtomcatlog(){
 _copygroovyfile "printTomcatLog.groovy"
}

yy-groovyconsole-runcronjob(){
 _copygroovyfile "runCronJob.groovy"
}
