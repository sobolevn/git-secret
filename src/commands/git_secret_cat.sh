#!/usr/bin/env bash


function cat {
  local homedir=''
  local passphrase=''

  OPTIND=1

  while getopts 'hd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'cat';;

      p) passphrase=$OPTARG;;

      d) homedir=$OPTARG;;

      *) _invalid_option_for 'cat';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  # Command logic:
  #local fsdb
  #fsdb=$(_get_secrets_dir_paths_mapping)

  for item in "$@"
  do
    local path  # absolute path
    local normalized_path # relative to the .git dir
    normalized_path=$(_git_normalize_filename "$item")
    path=$(_append_root_path "$normalized_path")

    local ignored
    ignored=$(_check_ignore "$path")

    # Checking that file is valid:
    if [ ! -f "$path" ]; then
      _abort "$item is not a file."
    elif [ "$ignored" -ne 0 ]; then
      # abort on un-ignored files
      _abort "$path is not an ignored file."
    else
      # The parameters are: filename, write-to-file, force, homedir, passphrase
      _decrypt "$path" "0" "0" "$homedir" "$passphrase"
    fi
  done
}
