### ssh ###

# Update a host in known_hosts if the fingerprint has changed
ssh-updatehost(){
  _help $1 && return
  _check_arg $1 "host name"
  ssh-keygen -R $1
}
