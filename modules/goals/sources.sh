### goals ###

goals-edit-lastweek(){
  _help $1 && return
  nav-diary
  ./edit_lastweek.sh
}

goals-edit-thisweek(){
  _help $1 && return
  nav-diary
  ./edit_thisweek.sh
}

goals-edit-nextweek(){
  _help $1 && return
  nav-diary
  ./edit_nextweek.sh
}

goals-commit(){
  _help $1 && return
  nav-goals
  git add .
  git commit -m "Update goals"
}

goals-push(){
  _help $1 && return
  nav-goals
  git push
}

goals-commitpush(){
  _help $1 && return
  goals-commit
  goals-push
}

goals-diff(){
  _help $1 && return
  nav-goals
  git diff
}

goals-create-thisweek(){
  _help $1 && return
  nav-diary
  ./create_thisweek.sh
}
alias goals-new="goals-create"

goals-create-nextweek(){
  _help $1 && return
  nav-diary
  ./create_nextweek.sh
}
alias goals-new-nextweek="goals-new-nextweek"
