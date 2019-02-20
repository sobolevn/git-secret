#!/usr/bin/env bash

function changes {
  local passphrase=""
  local git=0

  OPTIND=1

  while getopts 'hgd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'changes';;

      g) git=1;;

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

  _check_if_plaintexts_have_conflicts "${filenames[@]}";

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
    # now do a two-step to protect trailing newlines from the $() construct.
    local decrypted_x
    local decrypted
    decrypted_x=$(_decrypt "$path" "0" "0" "$homedir" "$passphrase"; echo x$?)
    decrypted="${decrypted_x%x*}"
    # we ignore the exit code because _decrypt will _abort if appropriate.

    if [[ 1 -eq $git ]]; then
      git_style_diff "$path" "$decrypted"
    else
      echo "changes in ${path}:"
      # diff the result:
      # we have the '|| true' because `diff` returns error code if files differ.
      diff -u <(echo -n "$decrypted") "$path" || true
    fi
  done
}

# Usage: git_style_diff "$path_file_on_disk" "$decrypted_content"
# Outputs a changes as git style conflicts
function git_style_diff {
  local path="$1"
  local decrypted="$2"

  _check_if_busybox_diff

  # Allow errors here
  set +e
  # We generate a random 16 char pattern, to avoid possible conflicts
  # with content of the plaintext file
  PATTERN=$(base64 < /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16)

  IF_NDEF="#ifndef ${PATTERN}"
  END_NDEF="#endif /\* ! ${PATTERN} \*/"
  ELSE="#else /\* ${PATTERN} \*/"
  IF_DEF="#ifdef ${PATTERN}"
  END_DEF="#endif /\* ${PATTERN} \*/"

  # One liner to replace the output of diff -D
  # Check man diff for more info
  # We use "_" as sed command separator, to avoid escaping "/"
  # and we use multiline commands to insert a new line, therefore the indentation
  # should not be changed
  diff_x=$(
    diff -D "${PATTERN}" "${path}" <(echo -n "$decrypted") | \

    # Replace if_ndef branch
    sed -e $"s_${IF_NDEF}_${MARKER_FILE_ON_DISK}_g" | \
    sed -e $"s_${END_NDEF}_${MARKER_SEPARATOR}\\
${MARKER_CONTENT_FROM_SECRET}_g" | \

    # Replace else
    sed -e $"s_${ELSE}_${MARKER_SEPARATOR}_g" | \

    # Replace if_def branch
    sed -e $"s_${IF_DEF}_${MARKER_FILE_ON_DISK}\\
${MARKER_SEPARATOR}_g" | \
    sed -e $"s_${END_DEF}_${MARKER_CONTENT_FROM_SECRET}_g";
    echo x$?
  );
  # No more errors allowed
  set -e

  diff="${diff_x%x*}"
  printf "%s" "${diff}"
}
