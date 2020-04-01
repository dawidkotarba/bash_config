### aliases ###

alias ll='ls -alh'
alias du='du -h'
alias rmf='rm -rf'
alias getpass="openssl rand -base64 20"
alias sha='shasum -a 256 '

# net aliases
alias ports='netstat -tulanp'
alias ping='ping -c 5'
alias ipe='curl ipinfo.io/ip'

# apps
alias r='ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'
alias wget='wget -c '
