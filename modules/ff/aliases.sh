### fuzzy ###

_findfile(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Search argument"
  local result=`find . -name "*$1*" -type f`
  echo $result
}

ff-vim(){
  vim `_findfile $1 | fzy`
}

ff-less(){
  less `_findfile $1 | fzy`
}

ff-atom(){
  atom `_findfile $1 | fzy`
}
