### git ###
__gitmakediff(){
 [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
 local diff_file_path=~/diff
 for commit in "$@"
  do
   git show $commit >> $diff_file_path
  done
}

git-config(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  __check $1 "email"
  __check $2 "user name"

  git config user.email "$1"
  git config user.name "$2"
}
alias git-config-dawidkotarba='git-config dawidkotarba dawidkotarba'

git-parent(){
 [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
 current_branch=`git rev-parse --abbrev-ref HEAD`
 git show-branch -a | ag '\*' | ag -v "$current_branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

git-branch(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  __check $1 "pattern"
  local pattern=$1;
  local remote_branch_names=`git br -r | grep $pattern | awk '{print $1}'`
  for remote_branch_name in $remote_branch_names
   do
    local local_branch_name=`echo $remote_branch_name | sed -r 's/^.{7}//'`
    __echo_info "Doing: git checkout -b $local_branch_name $remote_branch_name"
    git checkout -f
    git checkout -b $local_branch_name $remote_branch_name
   done
}

git-deletebranches(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  git checkout develop && git branch | grep -v develop | awk '{print $1}' | grep -v '*' | xargs git branch -D
}

git-difftask(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  local pattern=$1
  local commits=$(git llog | grep -i kotarba | grep $pattern | awk '{print $1}')
  local cmd="git-makediff $commits"
  __echo_info "Execute below:"
  echo __gitmakediff $commits
}

git-pushrefs(){
  [[ "$1" == "-h" ]] && __show_help ${FUNCNAME[0]} && return
  __check $1 "branchName"
  git push origin HEAD:refs/for/$1
}
