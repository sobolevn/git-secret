#!/usr/bin/env bash


function clean {
  OPTIND=1

  # shellcheck disable=SC2034
  while getopts 'vh' opt; do
    case "$opt" in
      v) _SECRETS_VERBOSE=1;;

      h) _show_manual_for 'clean';;

      *) _invalid_option_for 'clean';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  if [ $# -ne 0 ]; then
    _abort "clean does not understand params: $*"
  fi

  _user_required

  local filenames
  _list_all_added_files # sets array variable 'filenames'

  for filename in "${filenames[@]}"; do
    local path # absolute path
    encrypted_filename=$(_get_encrypted_filename "$filename")
    if [[ -f "$encrypted_filename" ]]; then
      rm "$encrypted_filename"
      echo "git-secret: deleted: $encrypted_filename"
    fi
  done
}
