### clip ###
_requires xclip

clip-file(){
  _help $1 && return
  local file_name=$1
  _filetoclipboard ${file_name}
}

clip-targets(){
  _help $1 && return
  xclip -selection clipboard -t TARGETS -o
}

clip-toimage(){
  _help $1 && return
  xclip -selection clipboard -t image/png -o > "`_get-desktop-path`/`_get-date`.png"
}

clip-totext(){
  _help $1 && return
  xclip -selection clipboard -o > "`_get-desktop-path`/`_get-date`.txt"
}
