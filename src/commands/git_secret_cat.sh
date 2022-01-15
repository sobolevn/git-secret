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
    path=$(_append_root_path "$filename")

    # now check if we're in a subdir of the repo, for #710
    # NOTE TO SELF: if we are in a subdir, reconstruct the path with the subdir in it.
    # note that this means the dir from _append_root_path is wrong, 
    # but if you fix it there other things break. 
    # Probably we should use this in a new function like _append_relative_root_path() (name?)
    local subdir
    subdir=$(git rev-parse --show-prefix)   # get the subdir of repo, like "subdir/"
    if [ ! -z "$subdir" ]; then
      path="$(dirname $path)/${subdir}/$(basename $path)" 
    fi

    # The parameters are: filename, write-to-file, force, homedir, passphrase
    _decrypt "$path" "0" "0" "$homedir" "$passphrase"
  done
}
