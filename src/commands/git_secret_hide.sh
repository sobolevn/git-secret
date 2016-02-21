#!/usr/bin/env bash


function _show_help_hide {
<<<<<<< HEAD
    cat <<-EOF
usage: git secret hide [-c] [-v]
encrypts all the files added by the 'add' command.

options:
  -c        deletes encrypted files before creating new ones.
  -v        shows which files are deleted.
  -h        shows this help.

EOF
=======
  echo "usage: git secret hide"
  echo "encrypts all the files added by the 'add' command."
  echo
  echo "  -c        deletes encrypted files before creating new ones."
  echo "  -v        shows which files are deleted."
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
  exit 0
}


function _optional_clean {
  OPTIND=1
  local clean=0
  local opt_string=""

  while getopts "cvh" opt; do
    case "$opt" in
<<<<<<< HEAD
      c) clean=1;;

      h) _show_help_hide;;

      v) opt_string="-v";;
=======
      c)  # -c is used for guaranted clean encryption.
        clean=1
      ;;

      h)
        _show_help_hide
      ;;

      v)
        opt_string="$opt_string -$opt"
      ;;
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  if [[ $clean -eq 1 ]]; then
<<<<<<< HEAD
    clean "$opt_string"
=======
    clean ${opt_string}
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
  fi
}


function hide {
  _optional_clean $@

  local counter=0
  while read line; do
    local encrypted_filename=$(_get_encrypted_filename $line)

    local recipients=$(_get_recepients)
    $GPGLOCAL --use-agent --yes --trust-model=always --encrypt $recipients -o "$encrypted_filename" "$line"

    counter=$((counter+1))
  done < "$SECRETS_DIR_PATHS_MAPPING"

  echo "done. all $counter files are hidden."
}
