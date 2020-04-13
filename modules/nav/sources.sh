### nav ###

function nav-repo(){
  _help $1 && return
  cd ${_REPOSITORY_PATH}
}

function nav-shellconfig(){
  _help $1 && return
  sh-navigate
}

function nav-desktop(){
  _help $1 && return
  cd /home/dawid/Pulpit
}

function nav-pliki(){
  _help $1 && return
  cd /media/dawid/Pliki
}
