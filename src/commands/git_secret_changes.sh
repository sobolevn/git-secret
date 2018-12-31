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

  filenames=("$@")  # list of positional params. global.
  if [[ ${#filenames[@]} -eq 0 ]]; then
    # Checking if no filenames are passed, show diff for all files.
    _list_all_added_files    # this sets the array variable 'filenames'
  fi

  IFS='
  '

  for filename in "${filenames[@]}"; do
    local path # absolute path
    local normalized_path # relative to the .git dir
    local encrypted_filename
    normalized_path=$(_git_normalize_filename "$filename")
    encrypted_filename=$(_get_encrypted_filename "$filename")

    if [[ ! -f "$encrypted_filename" ]]; then
        _abort "cannot find encrypted version of file: $filename"
    fi
    if [[ -n "$normalized_path" ]]; then
      path=$(_append_root_path "$normalized_path")
    else
      # Path was already normalized
      path=$(_append_root_path "$filename")
    fi
    
    if [[ ! -f "$path" ]]; then
        _abort "file not found. Consider using 'git secret reveal': $filename"
    fi

    # Now we have all the data required to do the last encryption and compare results:
    # now do a three-step to protect trailing newlines from the $() construct.
    local decrypted_x
    local exit_code_ignored
    local decrypted
    decrypted_x=$(_decrypt "$path" "0" "0" "$homedir" "$passphrase"; echo x$?)
    exit_code_ignored=${decrypted_x##*x}    # if _decrypt has an error it will _abort()
    decrypted="${decrypted_x%x*}"


    echo "changes in ${path}:"
    # diff the result:
    # we have the '|| true' because `diff` returns error if files differ.
    diff -u <(echo -n "$decrypted") "$path" || true
  done
}
