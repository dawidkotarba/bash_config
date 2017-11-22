### Java ###

jj-findinjar() {
  [[ "$1" == "-h" ]] && show_help $funcstack[1] && return
  checkarg $1 "path"
  checkarg $2 "keyword"
  local p=$1
  local keyword=$2
  for jar in $(find $p -name "*.jar"); do
    if [[ $(unzip -v ${jar} | grep "$keyword") ]]; then
      echo "$(basename $jar)"
    fi
  done
}
