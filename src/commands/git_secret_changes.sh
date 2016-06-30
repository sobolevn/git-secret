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

  local filenames="$1"
  if [[ -z "$filenames" ]]; then
    # Checking if no filenames are passed, show diff for all files.
    filenames=$(git secret list)
  fi

  IFS='
  '
  for filename in $filenames; do
    local decrypted
    local content
    local diff_result

    # Now we have all the data required:
    decrypted=$(_decrypt "$filename" "0" "0" "$homedir" "$passphrase")
    content=$(cat "$filename")

    # Let's diff the result:
    diff_result=$(diff <(echo "$decrypted") <(echo "$content")) || true
    # There was a bug in the previous version, since `diff` returns
    # exit code `1` when the files are different.
    echo "changes in ${filename}: ${diff_result}"
  done
}
