### fuzzy ###

_findfile(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Search argument"
  local result=`find . -name "*$1*" -type f`
  echo ${result}
}

_fuzzyfind(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  checkarg $1 "Search argument"
  _findfile $1 | fzy
}

ff-vim(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  vim `_fuzzyfind $1`
}

ff-less(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  less `_fuzzyfind $1`
}

ff-atom(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  atom `_fuzzyfind $1`
}

ff-cat(){
  ([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && show_help ${funcstack[1]} && return
  cat `_fuzzyfind $1`
}
