# shell config edition
sh-newfunction(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  kk-clipboard $SHELL_NEW_FUNCTION_FILE
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
 local module_name=$1
 local module_path=$SHELL_MODULES_PATH/$module_name
 [[ ! -d $module_name ]] && mkdir $SHELL_MODULES_PATH/$module_name
 echo "### help ###" >  $module_path/help.sh
 echo "### $module_name ###" > $module_path/aliases.sh
}

sh-source(){
  echo_info "Refreshing..."
  source $SHELL_MAIN_PATH
}

sh-edit(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local module_name=$1
 if [[ $module_name ]]
   then
     atom $SHELL_MODULES_PATH/$module_name/aliases.sh
     atom $SHELL_MODULES_PATH/$module_name/help.sh
   else
     atom $SHELL_MAIN_PATH
     atom $SHELL_CONFIG_PATH/help.sh
  fi
}

sh-edithelp(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 checkarg $1 "module_name"
 local module_name=$1
 [[ $module_name ]] && atom $SHELL_MODULES_PATH/$module_name/help.sh
}

sh-show(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 local module_name=$1
 [[ $module_name ]] && less $SHELL_MODULES_PATH/$module_name/aliases.sh || less $SHELL_MAIN_PATH
}

sh-commit(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 _git_add_commit_folder $SHELL_CONFIG_PATH
}

sh-push(){
 [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
 git -C $SHELL_CONFIG_PATH push
}

sh-commitpush(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  sh-commit
  sh-push
}

sh-revert(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  git -C $SHELL_CONFIG_PATH checkout -f
}

sh-refresh(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  echo_info "Rebasing latest shell config..."
  (cd $SHELL_CONFIG_PATH && git stash && git pull --rebase && git stash apply)
  echo_info "refreshing..."
  exec zsh
}

sh-navigate(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  cd $SHELL_CONFIG_PATH
}

sh-generatehelp(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  grep -rh "\w() *{" $1| tr -d " " | tr -d "(){" | xargs -I {} echo -e "$HELP_SUFFIX{}=''" | tr - _ >> help.sh
}
