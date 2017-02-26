#!/usr/bin/env bash


function killperson {
  OPTIND=1

  while getopts 'h' opt; do
    case "$opt" in
      h) _show_manual_for 'killperson';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  local emails=( "$@" )

  if [[ ${#emails[@]} -eq 0 ]]; then
    _abort "at least one email is required."
  fi

  for email in "${emails[@]}"; do
    $GPGLOCAL --batch --yes --delete-key "$email"
  done
}
