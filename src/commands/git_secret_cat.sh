#!/usr/bin/env bash


function cat {
  local homedir=''
  local passphrase=''

  OPTIND=1

  while getopts 'hd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'cat';;

      p) passphrase=$OPTARG;;

      d) homedir=$(_clean_windows_path "$OPTARG");;

      *) _invalid_option_for 'cat';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  # Command logic:

  for line in "$@"
  do
    local filename
    local path

    filename=$(_get_record_filename "$line")
    path=$(_prepend_relative_root_path "$filename")  # this uses the _relative version because of #710

    # The parameters are: filename, write-to-file, force, homedir, passphrase
    local quiet=1
    _decrypt "$path" "0" "0" "$homedir" "$passphrase" "$quiet"  # in cat mode, don't show output from gnupg
  done
}
