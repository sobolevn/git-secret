#!/usr/bin/env bash


function _optional_clean {
  local clean="$1"
  local verbose=${2:-""}

  if [[ $clean -eq 1 ]]; then
    _find_and_clean_formated "*$SECRETS_EXTENSION" "$verbose"
  fi
}


function _optional_delete {
  local delete="$1"
  local verbose=${2:-""}

  if [[ $delete -eq 1 ]]; then
    # We use custom formating here:
    if [[ ! -z "$verbose" ]]; then
      echo && echo 'removing unencrypted files:'
    fi

    while read -r line; do
      # So the formating would not be repeated several times here:
      _find_and_clean "*$line" "$verbose"
    done < "$SECRETS_DIR_PATHS_MAPPING"

    if [[ ! -z "$verbose" ]]; then
      echo
    fi
  fi

}


function hide {
  local clean=0
  local delete=0
  local verbose=''

  OPTIND=1

  while getopts 'cdvh' opt; do
    case "$opt" in
      c) clean=1;;

      d) delete=1;;

      v) verbose='v';;

      h) _show_manual_for 'hide';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  # We need user to continue:
  _user_required

  # If -c option was provided, it would clean the hidden files
  # before creating new ones.
  _optional_clean "$clean" "$verbose"

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

  # If -d option was provided, it would delete the source files
  # after we have already hidden them.
  _optional_delete "$delete" "$verbose"

  echo "done. all $counter files are hidden."
}
