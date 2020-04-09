### goals ###

goals-edit(){
  _help $1 && return
  nav-repo
  cd personal-goals/diary
  ./edit.sh
}
