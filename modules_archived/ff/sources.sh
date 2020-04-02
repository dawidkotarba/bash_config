### fuzzy ###

_findfile(){
  _check_help $1 && _show_help ${funcstack[1]} && return
  _check_arg $1 "Search argument"
  local result=`find . -name "*$1*" -type f`
  echo ${result}
}

_fuzzyfind(){
  _check_help $1 && _show_help ${funcstack[1]} && return
  _check_arg $1 "Search argument"
  _findfile $1 | fzy
}

ff-vim(){
  _check_help $1 && _show_help ${funcstack[1]} && return
  vim `_fuzzyfind $1`
}

ff-less(){
  _check_help $1 && _show_help ${funcstack[1]} && return
  less `_fuzzyfind $1`
}

ff-atom(){
  _check_help $1 && _show_help ${funcstack[1]} && return
  atom `_fuzzyfind $1`
}

ff-cat(){
  _check_help $1 && _show_help ${funcstack[1]} && return
  cat `_fuzzyfind $1`
}
