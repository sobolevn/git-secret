#!/usr/bin/env bash

function changes {
  local passphrase=""

  OPTIND=1

  while getopts 'hd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'changes';;

      p) passphrase=$OPTARG;;

      d) homedir=$OPTARG;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  local filenames="$*"
  if [[ -z "$filenames" ]]; then
    # Checking if no filenames are passed, show diff for all files.
    filenames=$(_list_all_added_files)
  fi

  IFS='
  '

  for filename in $filenames; do
    local decrypted
    local diff_result

    local path # absolute path
    local normalized_path # relative to the .git dir
    normalized_path=$(_git_normalize_filename "$filename")

    if [[ ! -z "$normalized_path" ]]; then
      path=$(_append_root_path "$normalized_path")
    else
      # Path was already normalized
      path=$(_append_root_path "$filename")
    fi

    # Now we have all the data required:
    decrypted=$(_decrypt "$path" "0" "0" "$homedir" "$passphrase")

    # Let's diff the result:
    diff_result=$(diff -u <(echo "$decrypted") "$path") || true
    # There was a bug in the previous version, since `diff` returns
    # exit code `1` when the files are different.
    echo "changes in ${path}:"
    echo "${diff_result}"
  done
}
