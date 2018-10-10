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
    _find_and_clean_formatted "*$SECRETS_EXTENSION" "$verbose"
  fi
}


function _optional_delete {
  local delete="$1"
  local verbose=${2:-""}

  if [[ $delete -eq 1 ]]; then
    local path_mappings
    path_mappings=$(_get_secrets_dir_paths_mapping)

    # We use custom formatting here:
    if [[ -n "$verbose" ]]; then
      echo && echo 'removing unencrypted files:'
    fi

    while read -r line; do
      # So the formatting would not be repeated several times here:
      local filename
      filename=$(_get_record_filename "$line")
      _find_and_clean "*$filename" "$verbose"
    done < "$path_mappings"

    if [[ -n "$verbose" ]]; then
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
  file_hash=$($checksum_local "$input_path" | gawk '{print $1}')

  echo "$file_hash"
}

function _optional_fsdb_update_hash {
  local key="$1"
  local hash="$2"
  local fsdb          # path_mappings

  fsdb=$(_get_secrets_dir_paths_mapping)

  _gawk_inplace -v key="'$key'" -v hash="$hash" "'$AWK_FSDB_UPDATE_HASH'" "$fsdb"
}


function hide {
  local clean=0
  local preserve=0
  local delete=0
  local fsdb_update_hash=0 # add checksum hashes to fsdb
  local verbose=''
  local force_continue=0

  OPTIND=1

  while getopts 'cFPdmvh' opt; do
    case "$opt" in
      c) clean=1;;

      F) force_continue=1;;

      P) preserve=1;;

      d) delete=1;;

      m) fsdb_update_hash=1;;

      v) verbose='v';;

      h) _show_manual_for 'hide';;

      *) _invalid_option_for 'hide';;
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
  local num_mappings
  num_mappings=$(gawk 'END{print NR}' "$path_mappings")

  # make sure all the unencrypted files needed are present
  local to_hide=()
  while read -r record; do
    to_hide+=("$record")  # add record to array
  done < "$path_mappings"

  local counter=0
  for record in "${to_hide[@]}"; do
    local filename
    local fsdb_file_hash
    local encrypted_filename
    filename=$(_get_record_filename "$record")
    fsdb_file_hash=$(_get_record_hash "$record")
    encrypted_filename=$(_get_encrypted_filename "$filename")

    local recipients
    recipients=$(_get_recipients)

    local secrets_dir_keys
    secrets_dir_keys=$(_get_secrets_dir_keys)

    local input_path
    local output_path
    input_path=$(_append_root_path "$filename")
    output_path=$(_append_root_path "$encrypted_filename")

    # Checking that file is valid:
    if [[ ! -f "$input_path" ]]; then
      # this catches the case where some decrypted files don't exist
      if [[ "$force_continue" -eq "0" ]]; then
        _abort "file not found: $input_path"
      else
        _warn "file not found, continuing anyway: $input_path"
      fi
    else
      file_hash=$(_get_file_hash "$input_path")
  
      # encrypt file only if required
      if [[ "$fsdb_file_hash" != "$file_hash" ]]; then
        # we depend on $recipients being split on whitespace
        # shellcheck disable=SC2086
        $SECRETS_GPG_COMMAND --homedir "$secrets_dir_keys" "--no-permission-warning" --use-agent --yes --trust-model=always --encrypt \
          $recipients -o "$output_path" "$input_path"
        local exit_code=$?
        if [[ "$exit_code" -ne 0 ]]; then
          # if gpg can't encrypt a file we asked it to, that's an error unless in force_continue mode
          if [[ $force_continue -eq 0 ]]; then
            _abort "problem encrypting file with gpg: exit code $exit_code: $filename" "2"
          else
            _warn "problem encrypting file with gpg: exit code $exit_code: $filename" 
          fi
        fi
        if [[ ! -f "$output_path" ]]; then
          # this catches case where gpg doesn't complain in exit_code, but file is not encrypted
          # which is always an error.
          if [[ $force_continue -eq 0 ]]; then
            _abort "problem encrypting file with gpg: $filename" "2"
          else
            _warn "problem encrypting file with gpg: $filename" 
          fi
        fi
  
        if [[ "$preserve" == 1 ]] && [[ -f "$output_path" ]]; then
          local perms
          perms=$($SECRETS_OCTAL_PERMS_COMMAND "$input_path")
          chmod "$perms" "$output_path"
        fi
  
  
        # If -m option was provided, it will update unencrypted file hash
        local key="$filename"
        local hash="$file_hash"
        # Update file hash if required in fsdb
        [[ "$fsdb_update_hash" -gt 0 ]] && \
          _optional_fsdb_update_hash "$key" "$hash"
        counter=$((counter+1))
      fi
    fi
  done

  # If -d option was provided, it would delete the source files
  # after we have already hidden them.
  _optional_delete "$delete" "$verbose"

  echo "done. $counter of $num_mappings files are hidden."
}
