### EXPORTS ###
export TERM='xterm-256color'

### PATHS ###
BASH_CONFIG_FOLDER_PATH=~/bash_config
BASH_ALIASES_PATH=$BASH_CONFIG_FOLDER_PATH/bash_aliases
BASH_APPS_PATH=$BASH_CONFIG_FOLDER_PATH/apps
BASH_PROJECTS_PATH=$BASH_CONFIG_FOLDER_PATH/projects
NOTES_PATH=~/.kde/share/apps/basket/baskets
REPOSITORY_PATH=~/REPOSITORY

### aliases ###
alias idea='sh /usr/local/bin/idea/bin/idea.sh &'
alias ll='ls -alh'
alias h='history'
alias j='jobs -l'
alias du='du -h'
alias top='htop'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias r='ranger'

### Functions ###
__git_add_commit_folder(){
 local FOLDER_NAME=$1
 git -C $FOLDER_NAME commit -a -m "update"
}

kk-bash-edit(){
 atom $BASH_ALIASES_PATH
}

kk-bash-show(){
 less $BASH_ALIASES_PATH
}

kk-bash-commit(){
 __git_add_commit_folder $BASH_CONFIG_FOLDER_PATH
}

kk-bash-push(){
 git -C $BASH_CONFIG_FOLDER_PATH push
}

kk-bash-commit-push(){
  kk-bash-commit
  kk-bash-push
}

kk-bash-revert(){
  git -C $BASH_CONFIG_FOLDER_PATH checkout -f
}

kk-bak(){
 local date=`date | awk '{print $3"-"$2"-"$4}'`
 cp -r $1 @$1_$date
}
alias bak='kk-bak'

kk-killall(){
  local PROCESS_NAME=$1
  ps aux | grep $PROCESS_NAME | awk '{print $2}' | xargs kill
}
alias killall='kk-killall'

kk-notes-commit(){
  __git_add_commit_folder $NOTES_PATH
}

k(){
  __echo_ok "refreshing..."
  exec bash
}

# DOCKER
kk-docker-start(){
  local CONTAINER_NAME=$1
  echo "Starting docker container: $1"
  sudo docker start $CONTAINER_NAME
  kk-docker-ip $CONTAINER_NAME
}
alias docker-start='kk-docker-start'

kk-docker-ip(){
  local CONTAINER_NAME=$1
  sudo docker inspect $CONTAINER_NAME | grep '"IPAddress"' | tail -n1
}
alias docker-ip='kk-docker-ip'

# GIT
kk-git-parent(){
 current_branch=`git rev-parse --abbrev-ref HEAD`
 git show-branch -a | ag '\*' | ag -v "$current_branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}
alias git-parent='kk-git-parent'

kk-git-makediff(){
 local DIFF_FILE_PATH=~/diff
 for commit in "$@"
  do
   git show $commit >> $DIFF_FILE_PATH
  done
}

kk-git-difftask(){
  local COMMITS=$(git llog | grep Kotarba | grep $1 | awk '{print $1}')
  local CMD="kk-git-makediff $COMMITS"
  echo kk-git-makediff $COMMITS
}

### NAVIGATE ###
kk-navigate-repo(){
  cd $REPOSITORY_PATH
}

### APPS ###
restclient(){
 (cd /usr/bin && java -jar restclient.jar &)
}

# HYBRIS
### conts ###
HYBRIS_LOG=hy.log

### generic ###
__on_hybris_platform(){
 rm -f $HYBRIS_LOG_PATH
 (cd $HYBRIS_HOME/bin/platform && $@ >> $HYBRIS_LOG_PATH &)
 sleep 1
 yy-log $@
}

__on_hybris_process(){
 local result=`ps -aux | grep hybris`
 echo "Operating on Hybris processes: $result"
 echo $result | awk {'print $2'} | xargs $@
}
# echo
__echo_err(){
 local color=`tput setaf 1`
 local reset=`tput sgr0`
 echo "${color}$@${reset}"
}

__echo_ok(){
 local color=`tput setaf 2`
 local reset=`tput sgr0`
 echo "${color}$@${reset}"
}

### yy ###
yy-home(){
 export HYBRIS_FOLDER_SUFFIX=$1
 export HYBRIS_HOME=$REPOSITORY_PATH/hybris_$HYBRIS_FOLDER_SUFFIX/hybris
 export HYBRIS_LOG_PATH=$HYBRIS_HOME/$HYBRIS_LOG
}

__check_hybris_suffix(){
  if [[ ! $HYBRIS_FOLDER_SUFFIX ]]
   then __echo_err "HYBRIS SUFFIX NOT SET!"
  fi
}

__get_hybris_process(){
  jcmd | grep tanukisoftware | awk {'print $1'}
}

yy-ps(){
 local HYBRIS_PS=`__get_hybris_process`
 if [[ ! $HYBRIS_PS ]]
  then __echo_err "HYBRIS IS NOT RUNNING"
  else __echo_ok "HYBRIS IS RUNNING: $HYBRIS_PS"

 fi
}

yy-navigate(){
 __check_hybris_suffix
 cd $HYBRIS_HOME
}

yy-navigate-custom(){
 __check_hybris_suffix
 cd $HYBRIS_HOME/bin/custom
}

yy-navigate-config(){
 __check_hybris_suffix
 cd $HYBRIS_HOME/config
}

yy-navigate-platform(){
 __check_hybris_suffix
 cd $HYBRIS_HOME/bin/platform
}

yy-log(){
 if [[ $@ != *'-nolog'* ]]
  then tail -f $HYBRIS_LOG_PATH
 fi
}

yy-log-show(){
 vim -R $HYBRIS_LOG_PATH
}

yy-log-tomcat(){
 (yy-navigate && cd log/tomcat && ls -lt | grep console | tail -1 | awk '{print $9}' | xargs tail -f)
}

yy-setenv(){
 (yy-navigate-platform && sh setantenv.sh)
}

__hybris-start(){
 __check_and_start_hybris_mysql
 __on_hybris_platform sh hybrisserver.sh debug $@
}

yy-kill(){
 ps aux | grep hybris | grep -v $HYBRIS_LOG | awk '{print $2}' | xargs kill
 yy-log $@
}

yy-kill9(){
 killall hybris -9
 yy-log $@
}

yy-visualvm(){
 jvisualvm --openpid `__get_hybris_process` &
}

yy-jcmd(){
 jcmd `__get_hybris_process` help
}

yy-config-local-properties(){
 __check_hybris_suffix
 atom $HYBRIS_HOME/config/local.properties
}

yy-config-local-extensions(){
 __check_hybris_suffix
 atom $HYBRIS_HOME/config/localextensions.xml
}

### HYBRIS ANT ###
yy-ant-all(){
  __on_hybris_platform ant all $@
}

yy-ant-clean(){
 __on_hybris_platform ant clean
}

yy-ant-clean-all(){
 __on_hybris_platform ant clean all $@
}

yy-ant-build(){
 __on_hybris_platform ant build $@
}

yy-jrebel(){
 local EXT_PATH=$1
 if [[ $EXT_PATH ]]
  then (cd $EXT_PATH && ant build)
  else ant build
 fi
}

yy-grunt(){
   local EXT_PATH=$1
    (cd $EXT_PATH && grunt)
}

yy-ant-updatesystem(){
 __on_hybris_platform ant updatesystem $@
}

yy-ant-junit(){
 __on_hybris_platform ant yunitinit
}

yy-ant-extgen(){
 __check_hybris_suffix
 cd $HYBRIS_HOME/bin/platform
 ant extgen
}

yy-ant-modulegen(){
 __check_hybris_suffix
 cd $HYBRIS_HOME/bin/platform
 ant modulegen
}

yy-ant-initialize(){
  __check_and_start_hybris_mysql
  __on_hybris_platform ant initialize $@
}

yy-ant-test(){
  __on_hybris_platform ant clean all yunitinit alltests
}

yy-ant-server(){
 __on_hybris_platform ant server
}

yy-copy-dbdriver(){
 __check_hybris_suffix
 cp ~/APPS/Hybris/mysql/mysql-connector-java-5.1.35-bin.jar $HYBRIS_HOME/bin/platform/lib/dbdriver
}

yy-docker-mysql-start(){
  __check_hybris_suffix
  local MYSQL_CONTAINER_NAME=mysql_$HYBRIS_FOLDER_SUFFIX
  kk-docker-start $MYSQL_CONTAINER_NAME
}

yy-docker-mysql-ip(){
  __check_hybris_suffix
  local MYSQL_CONTAINER_NAME=mysql_$HYBRIS_FOLDER_SUFFIX
  kk-docker-ip $MYSQL_CONTAINER_NAME
}

yy-docker-mysql-create(){
  __check_hybris_suffix
  local MYSQL_CONTAINER_NAME=mysql_$HYBRIS_FOLDER_SUFFIX
  local MYSQL_VERSION=""
  if [[ $1 ]]
   then MYSQL_VERSION=:$1
  fi

  sudo docker run --name $MYSQL_CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=root -d mysql/mysql-server$MYSQL_VERSION --innodb_flush_log_at_trx_commit=0
}

__check_hybris_mysql_running(){
  local IS_MYSQL_RUNNING=$(yy-docker-mysql-ip)
    if [[ $IS_MYSQL_RUNNING ]]
    then
      __echo_ok "hybris MYSQL is running"
      export HYBRIS_MYSQL_RUNNING=true
    else
      __echo_err "hybris MYSQL is NOT running"
      export HYBRIS_MYSQL_RUNNING=false
    fi
}

__check_and_start_hybris_mysql(){
  if [[ ! $HYBRIS_MYSQL_RUNNING ]]
   then
    yy-docker-mysql-start
    __check_hybris_mysql_running
  fi
}

### VPN ###
__openconnect_vpn(){
 local USER=$1
 local VPN_URL=$2
 local PARAMS=$3
 sudo openconnect -u $USER $VPN_URL $PARAMS
}

__openconnect_vpn_kill_signal(){
  local SIGNAL=$1
  local PATTERN=$2
  local PS=`ps aux | grep "sudo openconnect" | grep $PATTERN | awk '{print $2}' | head -1`
  if [[ $PS ]]
   then
    __echo_ok "$SIGNAL for VPN: $PATTERN"
    sudo kill -$SIGNAL $PS
   else __echo_err "Not connected to VPN: $PATTERN"
  fi
}

### PATH ###
source $BASH_CONFIG_FOLDER_PATH/path

### PROJECT SPECIFIC ###
source $BASH_PROJECTS_PATH/a
source $BASH_PROJECTS_PATH/e

### PROGRAMS ###
#z https://github.com/rupa/z.git
. $BASH_APPS_PATH/z/z.sh

# liquidprompt https://github.com/nojhan/liquidprompt.git
[[ $- = *i* ]] && source $BASH_APPS_PATH/liquidprompt/liquidprompt
