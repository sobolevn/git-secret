#!/usr/bin/env bash


function clean {
  OPTIND=1

  # shellcheck disable=2034
  while getopts 'vh' opt; do
    case "$opt" in
      v) _SECRETS_VERBOSE=1;;

      h) _show_manual_for 'clean';;

      *) _invalid_option_for 'clean';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  if [ $# -ne 0 ]; then 
    _abort "clean does not understand params: $*"
  fi

  _user_required

  # User should see properly formatted output:
  _find_and_clean_formatted "*$SECRETS_EXTENSION"
}
