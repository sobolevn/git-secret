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

  [[ ! -z "$verbose" ]] && echo && echo "cleaing:" || :  # bug with custom bash on OSX

  find . -name *$SECRETS_EXTENSION -type f | xargs rm -f$verbose

  [[ ! -z "$verbose" ]] && echo || :  # bug with custom bash on OSX

}
