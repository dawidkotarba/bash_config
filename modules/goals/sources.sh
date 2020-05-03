### goals ###

nav-goals(){
  _help $1 && return
  nav-repo
  cd personal-goals
}

nav-diary(){
  _help $1 && return
  nav-goals
  cd diary
}
goals-editreadme(){
  _help $1 && return
  nav-goals
  atom README.md
}

goals-editlastweek(){
  _help $1 && return
  nav-diary
  ./edit_lastweek.sh
}

goals-editlast(){
  _help $1 && return
  nav-diary
  ./edit_last.sh
}

goals-editthisweek(){
  _help $1 && return
  nav-diary
  ./edit_thisweek.sh
}

goals-editnextweek(){
  _help $1 && return
  nav-diary
  ./edit_nextweek.sh
}

goals-editbooks(){
  _help $1 && return
  _requires atom
  nav-goals
  atom books.md
}

goals-diff(){
  _help $1 && return
  nav-goals
  git diff
}

goals-createthisweek(){
  _help $1 && return
  nav-diary
  ./create_thisweek.sh
}
alias goals-new="goals-createthisweek"

goals-createnextweek(){
  _help $1 && return
  nav-diary
  ./create_nextweek.sh
}
alias goals-new-nextweek="goals-newnextweek"

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
