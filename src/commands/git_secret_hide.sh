#!/usr/bin/env bash


function _optional_clean {
  OPTIND=1
  local clean=0
  local opt_string=''

  while getopts 'cdvh' opt; do
    case "$opt" in
      c) clean=1;;

      h) _show_manual_for 'hide';;

      v) opt_string='-v';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  if [[ $clean -eq 1 ]]; then
    clean "$opt_string"
  fi
}


function _optional_delete {
  local verbose=''
  local delete=0

  OPTIND=1

  while getopts 'vd' opt; do
    case "$opt" in
      d) delete=1;;

      v) verbose="v";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  if [[ $delete -eq 1 ]]; then
    if [[ ! -z "$verbose" ]]; then
      echo && echo 'removing unencrypted files:'
    fi

    while read -r line; do
      find . -name "*$line" -type f -print0 | xargs -0 rm -f$verbose
    done < "$SECRETS_DIR_PATHS_MAPPING"

    if [[ ! -z "$verbose" ]]; then
      echo
    fi
  fi

}


function hide {
  _optional_clean "$@"

  local counter=0
  while read -r line; do
    local encrypted_filename
    encrypted_filename=$(_get_encrypted_filename "$line")

    local recipients
    recipients=$(_get_recepients)

    # shellcheck disable=2086
    $GPGLOCAL --use-agent --yes --trust-model=always --encrypt \
      $recipients -o "$encrypted_filename" "$line"

    counter=$((counter+1))
  done < "$SECRETS_DIR_PATHS_MAPPING"

  _optional_delete "$@"

  echo "done. all $counter files are hidden."
}
