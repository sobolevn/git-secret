#!/usr/bin/env bash


function _show_help_hide {
    cat <<-EOF
usage: git secret hide [-c] [-v]
encrypts all the files added by the 'add' command.

options:
  -c        deletes encrypted files before creating new ones.
  -v        shows which files are deleted.
  -h        shows this help.

EOF
  exit 0
}


function _optional_clean {
  OPTIND=1
  local clean=0
  local opt_string=""

  while getopts "cvh" opt; do
    case "$opt" in
      c) clean=1;;

      h) _show_help_hide;;

      v) opt_string="-v";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  if [[ $clean -eq 1 ]]; then
    clean "$opt_string"
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
