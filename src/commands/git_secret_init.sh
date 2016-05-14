#!/usr/bin/env bash


function init {
  OPTIND=1

  while getopts "h" opt; do
    case "$opt" in
      h) _show_manual_for "init";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  if [[ -d "$SECRETS_DIR" ]]; then
    _abort "already inited."
  fi

  local ignores=$(_check_ignore "$SECRETS_DIR"/)

  if [[ ! $ignores -eq 1 ]]; then
    _abort "'${SECRETS_DIR}/' is ignored."
  fi

  mkdir "$SECRETS_DIR" "$SECRETS_DIR_KEYS" "$SECRETS_DIR_PATHS"
  touch "$SECRETS_DIR_KEYS_MAPPING" "$SECRETS_DIR_PATHS_MAPPING"

  echo "'${SECRETS_DIR}/' created."
}
