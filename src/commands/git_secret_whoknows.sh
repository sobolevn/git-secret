#!/usr/bin/env bash


function whoknows {
  OPTIND=1

  while getopts "h?" opt; do
    case "$opt" in
      h) _show_manual_for "whoknows";;
    esac
  done

  _user_required

  local keys=$(_get_users_in_keyring)
  echo "$keys"
}
