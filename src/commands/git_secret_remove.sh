#!/usr/bin/env bash


function remove {
  local clean=0

  OPTIND=1

  while getopts 'ch' opt; do
    case "$opt" in
      c) clean=1;;

      h) _show_manual_for 'remove';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  # Validate if user exists:
  _user_required

  # Command logic:

  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  for item in "$@"; do
    if [[ ! -f "$item" ]]; then
      _abort "$item is not a file."
    fi

    _delete_line "$item" "$path_mappings"
    rm -f "${path_mappings}.bak"  # not all systems create '.bak'

    if [[ "$clean" == 1 ]]; then
      local encrypted_filename
      encrypted_filename=$(_get_encrypted_filename "$item")

      rm -f "$encrypted_filename"
    fi

  done

  echo 'removed from index.'
  echo "ensure that files: [$*] are now not ignored."
}
