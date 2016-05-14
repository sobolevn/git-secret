#!/usr/bin/env bash


function _show_help_usage {
    cat <<-EOF
usage: git secret usage
prints all the available commands.

options:
  -h        shows this help.

EOF
  exit 0
}


function usage {
  OPTIND=1

  while getopts "h?" opt; do
    case "$opt" in
      h) _show_manual_for "usage";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  local commands=""
  local separator="|"

  for com in $(compgen -A function); do
    if [[ ! $com == _* ]]; then
      commands+="$com$separator"
    fi
  done

  echo "usage: git secret [${commands%?}]"
}
