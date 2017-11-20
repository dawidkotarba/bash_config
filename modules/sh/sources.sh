# shell config edition
sh-newfunction(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  kk-clipboard $_SHELL_NEW_FUNCTION_FILEPATH
  echo_ok "Function template copied to clipboard"
}

sh-newhelp(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local help_code_line='[[ "$1" == "-h" ]] && show_help $funcstack[1] && return'
  echo "$help_code_line" | xclip -selection clipboard
  echo_ok "Help template copied to clipboard"
}

sh-newcheck(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local check_code_line='checkarg $1 "paramName"'
  echo "$check_code_line" | xclip -selection clipboard
  echo_ok "Check template copied to clipboard"
}

sh-newmodule(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "module_name"
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
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local module_name=$1
 local file_path=$_SHELL_MODULES_PATH/$module_name/sources.sh
 [[ -f $file_path ]] && atom $file_path || echo_err "No such file: $file_path"
}

sh-edithelp(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "module_name"
 local module_name=$1
 local file_path=$_SHELL_MODULES_PATH/$module_name/help.sh
 [[ -f $file_path ]] && atom $file_path || echo_err "No such file: $file_path"
}

sh-show(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local module_name=$1
 [[ $module_name ]] && less $_SHELL_MODULES_PATH/$module_name/sources.sh || less $_SHELL_MAIN_FILEPATH
}

sh-diff(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  (cd $_SHELL_CONFIG_PATH && git diff)
}

sh-commit(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _git_add_commit_folder $_SHELL_CONFIG_PATH
}

sh-push(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 git -C $_SHELL_CONFIG_PATH push
}

sh-commitpush(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  sh-commit
  sh-push
}

sh-revert(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  git -C $_SHELL_CONFIG_PATH checkout -f
}

sh-refresh(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  echo_info "Rebasing latest shell config..."
  (cd $_SHELL_CONFIG_PATH && git stash && git pull --rebase && git stash apply)
  echo_info "refreshing..."
  exec zsh
}

sh-navigate(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  cd $_SHELL_CONFIG_PATH
}

sh-updatehelp(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local functions=`grep -rh "\w() *{" sources.sh | tr -d " " | tr -d "(){" | xargs -I {} echo -e "$HELP_SUFFIX{}=" | tr - _`
  [[ ! -f help.sh ]] && (echo $functions >> help.sh) && return
  while read f
  do
   local help_for_function_exists=`grep "$f" help.sh`
   [[ -z $help_for_function_exists ]] && (echo $f >> help.sh)
  done <<< $functions
}
