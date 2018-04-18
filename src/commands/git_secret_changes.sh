#!/usr/bin/env bash

function changes {
  local passphrase=""

  OPTIND=1

  while getopts 'hd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'changes';;

      p) passphrase=$OPTARG;;

      d) homedir=$OPTARG;;

      *) _invalid_option_for 'changes';;
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
    #decrypted=$(_decrypt "$path" "0" "0" "$homedir" "$passphrase")

    # Let's diff the result:
    local secret_filename
    local diff_result

    secret_filename=$(_get_encrypted_filename "$path")
    #diff_result=$(git diff --shortstat "$secret_filename") || true
    if [[ ! -f "$secret_filename" ]]; then
        _abort "file not found: $secret_filename"
    fi
    diff_result=$(git diff --name-only "$secret_filename") || true
    
    if [[ "$diff_result" = "" ]]; then
      echo "${filename}${SECRETS_EXTENSION}: no change"
    else
      echo "${filename}${SECRETS_EXTENSION}: changed"
    fi
  done
}
