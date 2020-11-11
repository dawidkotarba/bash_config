### img ###

img-resize(){
  _help $1 && return
  _check_arg $1 "percentage"
  _check_arg $2 "image path"
  local percentage=$1
  local imgPath=$2
  mogrify -resize "${percentage}%" ${imgPath} ${imgPath}
}
