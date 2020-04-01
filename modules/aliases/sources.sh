### aliases ###

# If the last character of the alias value is a blank,
# then the next command word following the alias is also checked for alias expansion.
alias sudo='sudo '

# navigation
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# Make some of the file manipulation programs verbose
alias mv="mv -v"
alias rm="rm -vi"
alias cp="cp -v"

alias ll='ls -AlhF --color=auto'
alias rmf='rm -rf'
alias drives='df -h'
alias getpass='openssl rand -base64 20'
alias du='du -sh'
alias sha='shasum -a 256 '

# net aliases
alias ports='netstat -tulanp'
alias ping='ping -c 5'
alias ipe='curl ipinfo.io/ip'

# apps
alias r='ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'
alias wget='wget -c '
alias v='vim'
