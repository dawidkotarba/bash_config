#!/usr/bin/env zsh
source main.sh; sh-validate | grep 'Cannot source' && exit 1 || exit 0
