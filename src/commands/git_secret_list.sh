#!/usr/bin/env bash


function list {
  OPTIND=1

  while getopts 'h?' opt; do
    case "$opt" in
      h) _show_manual_for 'list';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  if [[ ! -s "$SECRETS_DIR_PATHS_MAPPING" ]]; then
    _abort "$SECRETS_DIR_PATHS_MAPPING is missing."
  fi

  while read -r line; do
    echo "$line"
  done < "$SECRETS_DIR_PATHS_MAPPING"
}
