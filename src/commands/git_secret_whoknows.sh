#!/usr/bin/env bash


function whoknows {
  OPTIND=1

  while getopts "h?" opt; do
    case "$opt" in
      h) _show_manual_for "whoknows";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # Validating, that we have a user:
  _user_required

  local keys

  # Getting the users from gpg:
  keys=$(_get_users_in_keyring)
  echo "$keys"
}
