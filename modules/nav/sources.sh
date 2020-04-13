### nav ###

nav-repo(){
  _help $1 && return
  cd ${_REPOSITORY_PATH}
}

nav-shellconfig(){
  _help $1 && return
  sh-navigate
}

nav-desktop(){
  _help $1 && return
  cd /home/dawid/Pulpit
}

nav-pliki(){
  _help $1 && return
  cd /media/dawid/Pliki
}

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
