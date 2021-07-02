### dev ###

dev-cleanidea-all(){
  _help $1 && return
  rm -rf ~/.config/JetBrains/*
  rm -rf ~/.local/share/JetBrains/consentOptions
  rm -rf ~/.java/.userPrefs
}

dev-cleanidea-2021-1(){
  _help $1 && return
  rm -rf ~/.config/JetBrains/IntelliJIdea2021.1/eval
  rm ~/.config/JetBrains/IntelliJIdea2021.1/options/other.xml
  rm -rf ~/.local/share/JetBrains/consentOptions
  rm -rf ~/.java/..userPrefs
}
