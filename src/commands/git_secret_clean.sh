#!/usr/bin/env bash


function clean {
  OPTIND=1

  local verbose=""
  while getopts "vh" opt; do
    case "$opt" in
      v) verbose="v";;

      h) _show_manual_for "clean";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  if [[ ! -z "$verbose" ]]; then
    echo && echo "cleaing:"
  fi

  find . -name "*$SECRETS_EXTENSION" -type f -print0 | xargs rm -f$verbose

  if [[ ! -z "$verbose" ]]; then
    echo
  fi

}
