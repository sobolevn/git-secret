#!/usr/bin/env bash


function add {
  _user_required

  local not_ignored=()

  for item in $@; do
    # Checking if all files in options are ignored:
    if [[ ! -f "$item" ]]; then
      _abort "$item is not a file."
    fi

    local ignored=$(_check_ignore "$item")
    if [[ ! "$ignored" -eq 0 ]]; then
      # collect unignored files.
      not_ignored+=("$item")
    fi
  done

  if [[ ! "${#not_ignored[@]}" -eq 0 ]]; then
    # and show them all at once.
    _abort "these files are not ignored: ${not_ignored[@]} ;"
  fi

  for item in $@; do
    # adding files into system, skipping duplicates.
    local already_in=$(_file_has_line "$item" "$SECRETS_DIR_PATHS_MAPPING")
    if [[ "$already_in" -eq 1 ]]; then
      echo "$item" >> "$SECRETS_DIR_PATHS_MAPPING"
    fi
  done

  echo "${#@} items added."
}
