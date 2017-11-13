### fuzzy ###

_findfile(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Search argument"
  local result=`find . -name "*$1*" -type f`
  echo $result
}

_fuzzyfind(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "Search argument"
  _findfile $1 | fzy
}

ff-vim(){
  vim `_fuzzyfind $1`
}

ff-less(){
  less `_fuzzyfind $1`
}

ff-atom(){
  atom `_fuzzyfind $1`
}

ff-cat(){
  cat `_fuzzyfind $1`
}
