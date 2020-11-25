# shell config edition
_pull-cloned-apps(){
 _help $1 && return
 for app in $(ls ${_SHELL_APPS_PATH});
  do
   local app_path="${_SHELL_APPS_PATH}/$app"
   git -C ${app_path} reset HEAD --hard
   git -C ${app_path} pull
  done
}

_getmodulepath(){
  _help $1 && return
  _check_arg $1 "module name"
  local module_name=$1
  echo ${_SHELL_MODULES_PATH}/${module_name}
}

_getmodulefilespath(){
  _help $1 && return
  _check_arg $1 "module name"
  echo "$(_getmodulepath $1)/files"
}

_editfile(){
 _help $1 && return
 _check_arg $1 "file name"
 _check_arg $2 "module name"
 local file_name=$1
 local module_name=$2
 local file_path="$(_getmodulepath $2)/$1"
 [[ -f ${file_path} ]] && (echo_ok "Opening ${file_path}" && nohup atom ${file_path} >/dev/null 2>&1 &) || echo_err "No such file: ${file_path}"
}

_filetoclipboard(){
  _help $1 && return
  cat $1 | xclip -selection clipboard
}
alias clip='_filetoclipboard'

sh-newfunction(){
  _help $1 && return
  clip "${_SHELL_MODULES_PATH}/sh/files/newfunction.sh"
  echo_ok "Function template copied to clipboard"
}

sh-newhelp(){
  _help $1 && return
  local help_code_line='_help $1 && return'
  echo "$help_code_line" | xclip -selection clipboard
  echo_ok "Help template copied to clipboard"
}

sh-newcheck(){
  _help $1 && return
  local check_code_line='_check_arg $1 "paramName"'
  echo "$check_code_line" | xclip -selection clipboard
  echo_ok "Check template copied to clipboard"
}

sh-newmodule(){
 _help $1 && return
 _check_arg $1 "module name"
 local modulename=$1
 local modulepath="$_SHELL_MODULES_PATH/$modulename"
 [[ ! -d ${modulepath} ]] && mkdir ${modulepath}
 echo "### help ###" >  ${modulepath}/help.sh
 echo "### $modulename ###" > ${modulepath}/module.sh
 mkdir ${modulepath}/files
}

sh-newusermodule(){
 _help $1 && return
 touch ${_USER_MODULE_FILEPATH}
 echo "User module ${_USER_MODULE_FILEPATH} has been created."
}

sh-editusermodule(){
 _help $1 && return
 atom ${_USER_MODULE_FILEPATH}
}

sh-archivemodule(){
 _help $1 && return
 _check_arg $1 "module name"
 local modulename=$1
 local modulepath="$_SHELL_MODULES_PATH/$modulename"
 local archivemodulepath="$_SHELL_MODULES_ARCHIVED_PATH/$modulename"
 mv ${modulepath} ${archivemodulepath}
}

sh-source(){
 _help $1 && return
  echo_info "Refreshing..."
  source ${_SHELL_MAIN_FILEPATH}
}

sh-validate(){
 _help $1 && return
 repeat 3 sh-source
}

sh-edit(){
  _help $1 && return
  local module_name=$1
  _editfile "module.sh" ${module_name}
}

sh-edithelp(){
  _help $1 && return
  local module_name=$1
  _editfile "help.sh" ${module_name}
}

sh-view(){
  _help $1 && return
  local module_name=$1
  local file_path="$(_getmodulepath ${module_name})/module.sh"
  less ${file_path}
}
alias sh-less='sh-view'

sh-pull(){
  git -C ${_SHELL_CONFIG_PATH} pull
  _pull-cloned-apps
}

sh-show(){
 _help $1 && return
 local module_name=$1
 [[ ${module_name} ]] && less ${_SHELL_MODULES_PATH}/${module_name}/module.sh || less ${_SHELL_MAIN_FILEPATH}
}

sh-diff(){
  _help $1 && return
  (cd ${_SHELL_CONFIG_PATH} && git diff)
}

sh-st(){
  _help $1 && return
  (cd ${_SHELL_CONFIG_PATH} && git status)
}

sh-tig(){
  _help $1 && return
  _requires tig
  (cd ${_SHELL_CONFIG_PATH} && tig)
}

sh-tis(){
  _help $1 && return
  (cd ${_SHELL_CONFIG_PATH} && tis)
}

sh-commit(){
  _help $1 && return
  sh-updatehelp
 _git_add_commit_folder ${_SHELL_CONFIG_PATH}
}

sh-push(){
 _help $1 && return
 git -C ${_SHELL_CONFIG_PATH} push
}

sh-commitpush(){
  _help $1 && return
  sh-commit
  sh-push
}

sh-revert(){
  _help $1 && return
  git -C ${_SHELL_CONFIG_PATH} checkout -f
}

sh-refresh(){
  _help $1 && return
  echo_info "Rebasing latest shell config..."
  (cd ${_SHELL_CONFIG_PATH} && git stash && git pull --rebase && git stash apply)
  echo_info "refreshing..."
  exec zsh
}

sh-navigate(){
  _help $1 && return
  local module=$1
  if [[ ${module} ]]
   then cd ${_SHELL_CONFIG_PATH}/modules/${module}
   else cd ${_SHELL_CONFIG_PATH}
  fi
}

sh-updatehelp(){
  _help $1 && return
  local current_path=`pwd`
  echo "current_path $current_path"

  for file in ${_SHELL_MODULES_PATH}/*; do
    if [[ -d "$file" ]]; then
      cd ${file}
      echo "Updating help from ${file} module."
      local functions=`grep -rh "\w() *{" module.sh | tr -d " " | tr -d "(){" | xargs -I {} echo -e "$HELP_SUFFIX{}=" | tr - _`
      [[ ! -f help.sh ]] && (echo ${functions} >> help.sh) && return
      while read f
      do
       local help_for_function_exists=`grep "$f" help.sh`
       [[ -z ${help_for_function_exists} ]] && (echo ${f} >> help.sh)
      done <<< ${functions}
    fi
   done

   cd ${current_path}
}

sh-what(){
  _help $1 && return
  _check_arg $1 "Function name pattern"
  local pattern=$1
  grep '()' ${_SHELL_FWD_FILEPATH} | grep ${pattern} | rev | cut -c 4- | rev
}
alias what='sh-what'
