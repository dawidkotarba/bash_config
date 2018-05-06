# shell config edition
_requires tig

_pull-cloned-apps(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 for app in $(ls $_SHELL_APPS_PATH);
  do
   local app_path="$_SHELL_APPS_PATH/$app"
   git -C $app_path reset HEAD --hard
   git -C $app_path pull
  done
}

_getmodulepath(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  checkarg $1 "module name"
  local module_name=$1
  echo $_SHELL_MODULES_PATH/$module_name
}

_getmodulefilespath(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  checkarg $1 "module name"
  echo "$(_getmodulepath $1)/files"
}

_editfile(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 checkarg $1 "file name"
 checkarg $2 "module name"
 local file_name=$1
 local module_name=$2
 local file_path="$(_getmodulepath $2)/$1"
 [[ -f $file_path ]] && (echo_ok "Opening editor..." && atom $file_path) || echo_err "No such file: $file_path"
}

_filetoclipboard(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  cat $1 | xclip -selection clipboard
}
alias clip='_filetoclipboard'

sh-newfunction(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  clip $_SHELL_NEW_FUNCTION_FILEPATH
  echo_ok "Function template copied to clipboard"
}

sh-newhelp(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  local help_code_line='([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return'
  echo "$help_code_line" | xclip -selection clipboard
  echo_ok "Help template copied to clipboard"
}

sh-newcheck(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  local check_code_line='checkarg $1 "paramName"'
  echo "$check_code_line" | xclip -selection clipboard
  echo_ok "Check template copied to clipboard"
}

sh-newmodule(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 checkarg $1 "module name"
 local modulename=$1
 local modulepath="$_SHELL_MODULES_PATH/$modulename"
 [[ ! -d $modulepath ]] && mkdir $modulepath
 echo "### help ###" >  $modulepath/help.sh
 echo "### $modulename ###" > $modulepath/sources.sh
 mkdir $modulepath/files
}

sh-source(){
  echo_info "Refreshing..."
  source $_SHELL_MAIN_FILEPATH
}

sh-edit(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  local module_name=$1
  _editfile "sources.sh" $module_name
}

sh-edithelp(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  local module_name=$1
  _editfile "help.sh" $module_name
}

sh-pull(){
  git -C $_SHELL_CONFIG_PATH pull
  _pull-cloned-apps
}

sh-show(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 local module_name=$1
 [[ $module_name ]] && less $_SHELL_MODULES_PATH/$module_name/sources.sh || less $_SHELL_MAIN_FILEPATH
}

sh-diff(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  (cd $_SHELL_CONFIG_PATH && git diff)
}

sh-tig(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  (cd $_SHELL_CONFIG_PATH && tig)
}

sh-tis(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  (cd $_SHELL_CONFIG_PATH && tis)
}

sh-commit(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 _git_add_commit_folder $_SHELL_CONFIG_PATH
}

sh-push(){
 ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
 git -C $_SHELL_CONFIG_PATH push
}

sh-commitpush(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  sh-commit
  sh-push
}

sh-revert(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  git -C $_SHELL_CONFIG_PATH checkout -f
}

sh-refresh(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  echo_info "Rebasing latest shell config..."
  (cd $_SHELL_CONFIG_PATH && git stash && git pull --rebase && git stash apply)
  echo_info "refreshing..."
  exec zsh
}

sh-navigate(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  local module=$1
  if [[ $module ]]
   then cd $_SHELL_CONFIG_PATH/modules/$module
   else cd $_SHELL_CONFIG_PATH
  fi
}

sh-updatehelp(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help $funcstack[1] && return
  local functions=`grep -rh "\w() *{" sources.sh | tr -d " " | tr -d "(){" | xargs -I {} echo -e "$HELP_SUFFIX{}=" | tr - _`
  [[ ! -f help.sh ]] && (echo $functions >> help.sh) && return
  while read f
  do
   local help_for_function_exists=`grep "$f" help.sh`
   [[ -z $help_for_function_exists ]] && (echo $f >> help.sh)
  done <<< $functions
}
