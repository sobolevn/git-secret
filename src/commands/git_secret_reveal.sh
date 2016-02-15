#!/usr/bin/env bash


function _show_help_reveal {
  echo "usage: git secret reveal"
  echo "unencrypts all the files added by the 'add' command."
  echo
  echo "  -d        specifies --homedir option for gpg."
  exit 0
}


function reveal {
  _user_required

  OPTIND=1
  local homedir=""
  local passphrase=""

  while getopts "hd:p:" opt; do
    case "$opt" in
      h)
        _show_help_reveal
      ;;

      p)
        passphrase=$OPTARG
      ;;

      d)
        homedir=$OPTARG
      ;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  local counter=0
  while read line; do
    local encrypted_filename=$(_get_encrypted_filename "$line")

    local base="$SECRETS_GPG_COMMAND --use-agent -q --decrypt"
    if [[ ! -z "$homedir" ]]; then
      base="$base --homedir=$homedir"
    fi

    if [[ ! -z "$passphrase" ]]; then
      base="$base --batch --yes --passphrase $passphrase"
    fi

    $base -o "$line" "$encrypted_filename"

    counter=$((counter+1))
  done < "$SECRETS_DIR_PATHS_MAPPING"

  echo "done. all $counter files are revealed."
}
