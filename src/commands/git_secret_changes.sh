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
    local decrypted
    local diff_result

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

    # Now we have all the data required:
    decrypted=$(_decrypt "$path" "0" "0" "$homedir" "$passphrase")
    # note that the $() construct strips trailing newlines! See #291

    #echo "# path is $path" >&3
    # Let's diff the result:
    diff_result=$(diff -u <(echo "$decrypted") "$path") || true
    # we have the '|| true' because `diff` returns 
    # exit code `1` when the files are different.

    # if we use echo -n above, then we get an 8 line diff:
        #  changes in /tmp/space file:                                                                                                                                                                         1/7
        # --- /dev/fd/63    2018-12-29 07:42:43.335908084 -0500
        # +++ "/tmp/space file"    2018-12-29 07:42:43.293909389 -0500
        # @@ -1 +1,2 @@
        # -hidden content юникод
        # \ No newline at end of file
        # +hidden content юникод
        # +new content

    # if we use 'echo' above, then we get a 6 line diff:
        # changes in /tmp/space file:                                                                                                                                                                         1/7
        # --- /dev/fd/63    2018-12-29 07:43:53.323735486 -0500
        # +++ "/tmp/space file"    2018-12-29 07:43:53.282736757 -0500
        # @@ -1 +1,2 @@
        # hidden content юникод
        # +new content

    echo "changes in ${path}:"
    echo "${diff_result}"
  done
}
