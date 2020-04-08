### goals ###

goals-diaryname(){
  _help $1 && return
  echo "$(date +%Y)-$(date +%m)-week$((($(date +%-d)-1)/7+1)).md"
}
