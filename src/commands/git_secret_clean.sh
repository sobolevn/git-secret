#!/usr/bin/env bash


function clean {
  local verbose=''

  OPTIND=1

  while getopts 'vh' opt; do
    case "$opt" in
      v) verbose="v";;

      h) _show_manual_for 'clean';;

      *) _invalid_option_for 'clean';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  # User should see properly formatted output:
  _find_and_clean_formatted "*$SECRETS_EXTENSION" "$verbose"
}
