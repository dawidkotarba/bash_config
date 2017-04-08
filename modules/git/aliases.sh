### git ###
# Creates a diff file from commits with provided pattern
__gitmakediff(){
 local diff_file_path=~/diff
 for commit in "$@"
  do
   git show $commit >> $diff_file_path
  done
}

# sets up the git username/email
git-config(){
  git config user.email "Dawid Kotarba"
  git config user.name "Dawid Kotarba"
}
# Finds parents of current branch
git-parent(){
 current_branch=`git rev-parse --abbrev-ref HEAD`
 git show-branch -a | ag '\*' | ag -v "$current_branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}


git-branch(){
  __help $1 "Creates local branches for all found remote branches with provided pattern"
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

# Deletes all local branches except develop
git-deletebranches(){
  git checkout develop && git branch | grep -v develop | awk '{print $1}' | grep -v '*' | xargs git branch -D
}

git-difftask(){
  local pattern=$1
  local commits=$(git llog | grep kotarba | grep $pattern | awk '{print $1}')
  local cmd="git-makediff $commits"
  __echo_info "Execute below:"
  echo __gitmakediff $commits
}
