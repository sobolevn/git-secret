#!/usr/bin/env bash


function list {
  OPTIND=1

  while getopts "h?" opt; do
    case "$opt" in
      h) _show_manual_for "list";;
    esac
  done

  _user_required

  if [[ ! -s "$SECRETS_DIR_PATHS_MAPPING" ]]; then
    exit 1
  fi

  while read line; do
    echo "$line"
  done < "$SECRETS_DIR_PATHS_MAPPING"
}
