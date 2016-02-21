#!/usr/bin/env bash


function list {
  _user_required

  if [[ ! -s "$SECRETS_DIR_PATHS_MAPPING" ]]; then
    exit 1
  fi

  while read line; do
    echo "$line"
  done < "$SECRETS_DIR_PATHS_MAPPING"
}
