#!/usr/bin/env bash


function killperson {
  OPTIND=1

  while getopts "h" opt; do
    case "$opt" in
      h) _show_manual_for "killperson";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  if [[ ${#@} -eq 0 ]]; then
    _abort "email is required."
  fi

  $GPGLOCAL --batch --yes --delete-key "$1"
}
