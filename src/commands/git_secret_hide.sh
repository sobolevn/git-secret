#!/usr/bin/env bash

# shellcheck disable=2016
AWK_FSDB_UPDATE_HASH='
BEGIN { FS=":"; OFS=":"; }
{
  if ( key == $1 )
  {
    print key,hash;
  }
  else
  {
    print $1,$2;
  }
}
'

function _optional_clean {
  local clean="$1"
  local verbose=${2:-""}

  if [[ $clean -eq 1 ]]; then
    _find_and_clean_formated "*$SECRETS_EXTENSION" "$verbose"
  fi
}


function _optional_delete {
  local delete="$1"
  local verbose=${2:-""}

  if [[ $delete -eq 1 ]]; then
    local path_mappings
    path_mappings=$(_get_secrets_dir_paths_mapping)

    # We use custom formating here:
    if [[ ! -z "$verbose" ]]; then
      echo && echo 'removing unencrypted files:'
    fi

    while read -r line; do
      # So the formating would not be repeated several times here:
      local filename
      filename=$(_get_record_filename "$line")
      _find_and_clean "*$filename" "$verbose"
    done < "$path_mappings"

    if [[ ! -z "$verbose" ]]; then
      echo
    fi
  fi
}

function _get_checksum_local {
  local checksum="$SECRETS_CHECKSUM_COMMAND"
  echo "$checksum"
}

function _get_file_hash {
  local input_path="$1" # Required
  local checksum_local
  local file_hash

  checksum_local="$(_get_checksum_local)"
  file_hash=$($checksum_local "$input_path" | awk '{print $1}')

  echo "$file_hash"
}

function _optional_fsdb_update_hash {
  local key="$1"
  local hash="$2"
  local fsdb          # path_mappings

  fsdb=$(_get_secrets_dir_paths_mapping)

  gawk -i inplace -v key="$key" -v hash="$hash" "$AWK_FSDB_UPDATE_HASH" "$fsdb"
}


function hide {
  local clean=0
  local delete=0
  local fsdb_update_hash=0 # add checksum hashes to fsdb
  local verbose=''

  OPTIND=1

  while getopts 'cdmvh' opt; do
    case "$opt" in
      c) clean=1;;

      d) delete=1;;

      m) fsdb_update_hash=1;;

      v) verbose='v';;

      h) _show_manual_for 'hide';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  # We need user to continue:
  _user_required

  # If -c option was provided, it would clean the hidden files
  # before creating new ones.
  _optional_clean "$clean" "$verbose"

  # Encrypting files:

  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local counter=0
  while read -r record; do
    local filename
    local fsdb_file_hash
    local encrypted_filename
    filename=$(_get_record_filename "$record")
    fsdb_file_hash=$(_get_record_hash "$record")
    encrypted_filename=$(_get_encrypted_filename "$filename")

    local recipients
    recipients=$(_get_recepients)

    local gpg_local
    gpg_local=$(_get_gpg_local)

    local input_path
    local output_path
    input_path=$(_append_root_path "$filename")
    output_path=$(_append_root_path "$encrypted_filename")

    file_hash=$(_get_file_hash "$input_path")

    # encrypt file only if required
    if [[ "$fsdb_file_hash" != "$file_hash" ]]; then
      # shellcheck disable=2086
      $gpg_local --use-agent --yes --trust-model=always --encrypt \
        $recipients -o "$output_path" "$input_path" > /dev/null 2>&1
      # If -m option was provided, it will update unencrypted file hash
      local key="$filename"
      local hash="$file_hash"
      # Update file hash if required in fsdb
      [[ "$fsdb_update_hash" -gt 0 ]] && \
        _optional_fsdb_update_hash "$key" "$hash"
    fi
    counter=$((counter+1))
  done < "$path_mappings"

  # If -d option was provided, it would delete the source files
  # after we have already hidden them.
  _optional_delete "$delete" "$verbose"

  echo "done. all $counter files are hidden."
}
