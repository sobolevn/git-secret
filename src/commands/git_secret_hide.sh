#!/usr/bin/env bash

# shellcheck disable=SC2016
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


function _optional_delete {
  local delete="$1"

  if [[ $delete -eq 1 ]]; then
    local path_mappings
    path_mappings=$(_get_secrets_dir_paths_mapping)

    # We use custom formatting here:
    if [[ -n "$_SECRETS_VERBOSE" ]]; then
      _message 'removing unencrypted files'
    fi

    while read -r line; do  # each line is a record like: filename: or filename:hash
      local filename
      filename=$(_get_record_filename "$line")
      if [[ -e "$filename" ]]; then 
        _message "removing: $filename"
        rm $filename
      fi
    done < "$path_mappings"
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

function _fsdb_update_hash {
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
  local update_only_modified=0
  local force_continue=0

  OPTIND=1

  while getopts 'cFPdmvh' opt; do
    case "$opt" in
      c) clean=1;;

      F) force_continue=1;;

      P) preserve=1;;

      d) delete=1;;

      m) update_only_modified=1;;

      v) _SECRETS_VERBOSE=1;;

      h) _show_manual_for 'hide';;

      *) _invalid_option_for 'hide';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  if [ $# -ne 0 ]; then
    _abort "hide does not understand params: $*"
  fi

  # We need user to continue:
  _user_required

  # If -c option was provided, clean the hidden files
  # before creating new ones.
  if [[ $clean -eq 1 ]]; then
    _find_and_remove_secrets_formatted "*$SECRETS_EXTENSION"
  fi

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

  local recipients
  recipients=$(_get_recipients)

  local secrets_dir_keys
  secrets_dir_keys=$(_get_secrets_dir_keys)

  local counter=0
  for record in "${to_hide[@]}"; do
    local filename
    local fsdb_file_hash
    local encrypted_filename
    filename=$(_get_record_filename "$record")
    fsdb_file_hash=$(_get_record_hash "$record")
    encrypted_filename=$(_get_encrypted_filename "$filename")

    local input_path
    local output_path
    input_path=$(_prepend_root_path "$filename")
    output_path=$(_prepend_root_path "$encrypted_filename")

    # Checking that file is valid:
    if [[ ! -f "$input_path" ]]; then
      # this catches the case where some decrypted files don't exist
      _warn_or_abort "file not found: $input_path" "1" "$force_continue"
    else
      file_hash=$(_get_file_hash "$input_path")

      # encrypt file only if required
      if [[ "$update_only_modified" -eq 0 ]] ||
         [[ "$fsdb_file_hash" != "$file_hash" ]]; then

        local args=( --homedir "$secrets_dir_keys" --use-agent --yes '--trust-model=always' --encrypt )

        # SECRETS_GPG_ARMOR is expected to be empty or '1'.
        # Empty means 'off', any other value means 'on'.
        # See: https://github.com/sobolevn/git-secret/pull/661
        # shellcheck disable=SC2153
        if [[ -n "$SECRETS_GPG_ARMOR" ]] &&
           [[ "$SECRETS_GPG_ARMOR" -ne 0 ]]; then
          args+=( '--armor' )
        fi

        # we no longer use --no-permission-warning here in non-verbose mode, for #811

        # we depend on $recipients being split on whitespace
        # shellcheck disable=SC2206
        args+=( $recipients -o "$output_path" "$input_path" )

        set +e  # disable 'set -e' so we can capture exit_code

     	  # For info about `3>&-` see:
        # https://github.com/bats-core/bats-core#file-descriptor-3-read-this-if-bats-hangs
        local gpg_output
        gpg_output=$($SECRETS_GPG_COMMAND "${args[@]}" 3>&-)  # we leave stderr alone
        local exit_code=$?

        set -e  # re-enable set -e

        local error=0
        if [[ "$exit_code" -ne 0 ]] || [[ ! -f "$output_path" ]]; then
          error=1
        fi

        if [[ "$error" -ne 0 ]] || [[ -n "$_SECRETS_VERBOSE" ]]; then
          if [[ -n "$gpg_output" ]]; then
            echo "$gpg_output"
          fi
        fi

        if [[ ! -f "$output_path" ]]; then
          # if gpg can't encrypt a file we asked it to, that's an error unless in force_continue mode.
          _warn_or_abort "problem encrypting file with gpg: exit code $exit_code: $filename" "$exit_code" "$force_continue"
        else
          counter=$((counter+1))
          if [[ "$preserve" == 1 ]]; then
            local perms
            perms=$($SECRETS_OCTAL_PERMS_COMMAND "$input_path")
            chmod "$perms" "$output_path"
          fi
        fi

        # Update file hash for future use of -m
        local key="$filename"
        local hash="$file_hash"
        _fsdb_update_hash "$key" "$hash"
      fi
    fi
  done

  # If -d option was provided, it would delete the source files
  # after we have already hidden them.
  _optional_delete "$delete"

  _message "done. $counter of $num_mappings files are hidden."
}
