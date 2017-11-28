#!/usr/bin/env bash


function killperson {
  OPTIND=1

  while getopts 'h' opt; do
    case "$opt" in
      h) _show_manual_for 'killperson';;

      *) _invalid_option_for 'killperson';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  # Command logic:

  local emails=( "$@" )

  if [[ ${#emails[@]} -eq 0 ]]; then
    _abort "at least one email is required."
  fi

  # Getting the local `gpg` command:
  local gpg_local
  gpg_local=$(_get_gpg_local)

  for email in "${emails[@]}"; do
    $gpg_local --batch --yes --delete-key "$email"
  done

  echo 'removed keys.'
  echo "now [$*] do not have an access to the repository."
  echo 'make sure to hide the existing secrets again.'
}
