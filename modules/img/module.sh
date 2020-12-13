### img ###

img-resize(){
  _help $1 && return
  _check_arg $1 "percentage"
  _check_arg $2 "image path"
  local percentage=$1
  local imgPath=$2
  mogrify -resize "${percentage}%" ${imgPath} ${imgPath}
}

# Converts PDF to image
img-frompdf(){
  _help $1 && return
  _requires poppler-utils
  _check_arg $1 "input file"
  local inputfile=$1
  pdftoppm -jpeg ${inputfile} "${inputfile}.jpg"
}
