### Java ###

java-findinjar() {
  _help $1 && return
  _check_arg $1 "path"
  _check_arg $2 "keyword"
  local p=$1
  local keyword=$2
  for jar in $(find ${p} -name "*.jar"); do
    if [[ $(unzip -v ${jar} | grep "$keyword") ]]; then
      echo "$(basename ${jar})"
    fi
  done
}

java-newbean(){
  _help $1 && return
  _check_arg $1 "full class name"
  local class_name=$1
  if [[ -z $class_name ]] && class_name=`xclip -o`
  python ${_SHELL_MODULES_PATH}/jj/files/spring_newbean.py ${class_name} | xclip -selection clipboard
}
alias bean=java-newbean
