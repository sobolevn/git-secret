#!/usr/bin/env bash


function remove {
  _user_required

  for item in $@; do
    if [[ ! -f "$item" ]]; then
      _abort "$item is not a file."
    fi

    _delete_line "$item" "$SECRETS_DIR_PATHS_MAPPING"
  done

  local all=${@}
  echo "removed from index."
  echo "ensure that files: [$all] are now not ignored."
}
