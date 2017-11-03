### fuzzy ###

ff-vim(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Search argument"
  vim `find . -name "*$1*" | fzy`
}

ff-less(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Search argument"
  less `find . -name "*$1*" | fzy`
}

ff-atom(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Search argument"
  atom `find . -name "*$1*" | fzy`
}
