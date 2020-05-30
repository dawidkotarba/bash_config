### git ###
_git_add_commit_folder(){
  _help $1 && return
 _check_arg $1 "folder name"
 local folder_name=$1
 local modified_files=`(cd $1 && git ls-files -m)`
 if [[ ${modified_files} ]]
  then
    local joined_modified_files=`_join "," ${modified_files}`
    local git_message="Update: $joined_modified_files"
    git -C ${folder_name} commit -a -m "$git_message"
    echo_info "$git_message"
  else
    echo_warn "Nothing to commit."
 fi
}

# Creates a diff file from commits with provided pattern
_gitmakediff(){
 _help $1 && return
 local diff_file_path=~/diff
 for commit in "$@"
  do
   git show ${commit} >> ${diff_file_path}
  done
}

# Sets up the git username/email. Usage: git-config "email@email.com" "User Name"
git-config(){
  _help $1 && return
  _check_arg $1 "email"
  _check_arg $2 "user name"

  git config user.email "$1"
  git config user.name "$2"
}
alias git-configdawidkotarba='git-config dawidkotarba dawidkotarba'

# Finds parents of current branch
git-parent(){
 _help $1 && return
 current_branch=`git rev-parse --abbrev-ref HEAD`
 git show-branch -a | ag '\*' | ag -v "$current_branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

# Creates local branches for all found remote branches with provided pattern
git-branch(){
  _help $1 && return
  _check_arg $1 "pattern"
  local pattern=$1;
  local remote_branch_names=`git br -r | grep ${pattern} | awk '{print $1}'`
  for remote_branch_name in ${remote_branch_names}
   do
    local local_branch_name=`echo ${remote_branch_name} | sed -r 's/^.{7}//'`
    echo_info "Doing: git checkout -b $local_branch_name $remote_branch_name"
    git checkout -f
    git checkout -b ${local_branch_name} ${remote_branch_name}
   done
}

# Delete all merged branches to master/develop locally
git-deletemergedlocal(){
  _help $1 && return
  git branch --merged | grep -v '\*\|master\|develop' | xargs -n 1 git branch -d
}

# Delete all merged branches to master/develop locally and remotely
git-deletemergedremote(){
  _help $1 && return
  git branch -r --merged | grep -v '\*\|master\|develop' | sed 's/origin\///' | xargs -n 1 git push --delete origin
}

git-difftask(){
  _help $1 && return
  local pattern=$1
  local commits=$(git llog | grep -i kotarba | grep ${pattern} | awk '{print $1}')
  local cmd="git-makediff $commits"
  echo_info "Execute below:"
  echo _gitmakediff ${commits}
}

# Git pushrefs to specified branch. Usage: git-pushrefs release_0.1
git-pushrefs(){
  _help $1 && return
  _check_arg $1 "branchName"
  git push origin HEAD:refs/for/$1
}
