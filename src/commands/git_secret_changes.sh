#!/usr/bin/env bash

function changes {
  OPTIND=1

  while getopts "hd:p:" opt; do
    case "$opt" in
      h) _show_manual_for "changes";;

      p) passphrase=$OPTARG;;

      d) homedir=$OPTARG;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  local filenames="$1"
  if [[ -z "$filenames" ]]; then
    # Checking if no filenames are passed, show diff for all files.
    filenames=$(git secret list)
  fi

  local previous_commit=$(git rev-parse HEAD)

  for filename in "$filenames"; do
    # Meta information:
    local encrypted_filename=$(_get_encrypted_filename "$filename")
    local last_encrypted=$(git show "${previous_commit}:${encrypted_filename}")

    # Now we have all the data required:
    local decrypted=$(_decrypt "$filename" "0" "0" "$homedir" "$passphrase")
    local content=$(cat "$filename")

    local diff_result=$(diff <(echo "$decrypted") <(echo "$content"))
    echo "changes in ${filename}: ${diff_result}"
  done
}
