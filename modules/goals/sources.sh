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

goals-edit(){
  _help $1 && return
  nav-diary
  ./edit.sh
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
