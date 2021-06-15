### dev ###

dev-intellijcleanup(){
  _help $1 && return
  rm -rf ~/.config/JetBrains/*
  rm -rf ~/.local/share/JetBrains/consentOptions
  rm -rf ~/.java/.userPrefs
}
