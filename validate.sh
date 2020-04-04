#!/usr/bin/env zsh

ERROR=$(zsh main.sh 2>&1 >/dev/null)
[[ ! -z "$ERROR" ]] && exit 1 || exit 0
