#!/usr/bin/env bash


function _show_help_hide {
  echo "usage: git secret hide"
  echo "encrypts all the files added by the 'add' command."
  echo
  echo "  -c        clean files before creating new ones."
  echo "  -v        shows which files are deleted."
  exit 0
}


function _optional_clean {
  OPTIND=1
  local clean=0
  local opt_string=""

  while getopts "cvh" opt; do
    case "$opt" in
      c)  # -c is used for guaranted clean encryption.
        clean=1
      ;;

      h)
        _show_help_hide
      ;;

      *)
        opt_string="$opt_string -$opt"
      ;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  if [[ $clean -eq 1 ]]; then
    clean ${opt_string}
  fi
}


function hide {
  _user_required

  _optional_clean $@

  local counter=0
  while read line; do
    local encrypted_filename=$(_get_encrypted_filename $line)

    local recipients=$($GPGLOCAL --list-keys | sed -n 's/.*<\(.*\)>.*/-r\1/p')
    $GPGLOCAL --use-agent --yes --trust-model=always --encrypt $recipients -o "$encrypted_filename" "$line"

    counter=$((counter+1))
  done < $SECRETS_DIR_PATHS_MAPPING

  echo "done. all $counter files are hidden."
}
