### goals ###

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

goals-diff(){
  _help $1 && return
  nav-goals
  git diff
}
