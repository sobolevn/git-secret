#!/usr/bin/env bash


function add {
  _user_required

  local not_ignored=()

  for item in $@; do
    # Checking if all files in options are ignored:
<<<<<<< HEAD
    if [[ ! -f "$item" ]]; then
=======
    if [[ ! -f $item ]]; then
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
      _abort "$item is not a file."
    fi

    local ignored=$(_check_ignore "$item")
<<<<<<< HEAD
    if [[ ! "$ignored" -eq 0 ]]; then
=======
    if [[ ! $ignored -eq 0 ]]; then
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
      # collect unignored files.
      not_ignored+=("$item")
    fi
  done

<<<<<<< HEAD
  if [[ ! "${#not_ignored[@]}" -eq 0 ]]; then
=======
  if [[ ! ${#not_ignored[@]} -eq 0 ]]; then
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    # and show them all at once.
    _abort "these files are not ignored: ${not_ignored[@]} ;"
  fi

  for item in $@; do
    # adding files into system, skipping duplicates.
    local already_in=$(_file_has_line "$item" "$SECRETS_DIR_PATHS_MAPPING")
<<<<<<< HEAD
    if [[ "$already_in" -eq 1 ]]; then
      echo "$item" >> "$SECRETS_DIR_PATHS_MAPPING"
=======
    if [[ $already_in -eq 1 ]]; then
      echo $item >> $SECRETS_DIR_PATHS_MAPPING
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    fi
  done

  echo "${#@} items added."
}
