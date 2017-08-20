sh-newfunction(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  kk-clipboard $SHELL_NEW_FUNCTION_FILE
  echo_ok "Function template copied to clipboard"
}

sh-newhelp(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local help_code_line='[[ "$1" == "-h" ]] && show_help $funcstack[1] && return'
  echo "$help_code_line" | xclip -selection clipboard
  echo_ok "Help template copied to clipboard"
}

sh-newcheck(){
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  local check_code_line='checkarg $1 "paramName"'
  echo "$check_code_line" | xclip -selection clipboard
  echo_ok "Check template copied to clipboard"
}
