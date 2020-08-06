### clip ###

clip-file(){
  _help $1 && return
  _requires xclip
  local file_name=$1
  _filetoclipboard ${file_name}
}

clip-targets(){
  _help $1 && return
  _requires xclip
  xclip -selection clipboard -t TARGETS -o
}

clip-toimage(){
  _help $1 && return
  _requires xclip
  xclip -selection clipboard -t image/png -o > "`_get-desktop-path`/`_get-date`.png"
}

clip-totext(){
  _help $1 && return
  _requires xclip
  xclip -selection clipboard -o > "`_get-desktop-path`/`_get-date`.txt"
}
