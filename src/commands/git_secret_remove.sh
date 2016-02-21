#!/usr/bin/env bash


function _show_help_remove {
<<<<<<< HEAD
      cat <<-EOF
usage: git secret remove [-c] <pathspec..>
removes files from git-secret's index."

options:
  -c        deletes existing real encrypted files.
  -h        shows this help.

EOF
=======
  echo "usage: git secret remove [files..]"
  echo "removes files from git-secret's index."
  echo
  echo "  -c        deletes existing real files."
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
  exit 0
}


function remove {
  OPTIND=1
  local clean=0

  while getopts "ch" opt; do
    case "$opt" in
<<<<<<< HEAD
      c) clean=1;;

      h) _show_help_remove;;
=======
      c)
        clean=1
      ;;

      h)
        _show_help_remove
      ;;
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # validate if user exist:
  _user_required

  for item in $@; do
    if [[ ! -f "$item" ]]; then
      _abort "$item is not a file."
    fi

    _delete_line "$item" "$SECRETS_DIR_PATHS_MAPPING"
    rm -f "${SECRETS_DIR_PATHS_MAPPING}.bak"

    if [[ "$clean" == 1 ]]; then
      local encrypted_filename=$(_get_encrypted_filename "$item")
      rm -f "$encrypted_filename"
    fi

  done

  local all=${@}

  echo "removed from index."
  echo "ensure that files: [$all] are now not ignored."
}
