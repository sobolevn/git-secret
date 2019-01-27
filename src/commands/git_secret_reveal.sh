#!/usr/bin/env bash


function reveal {
  local homedir=''
  local passphrase=''
  local force=0             # this means 'clobber without warning'
  local force_continue=0    # this means 'continue if we have decryption errors'
  local preserve=0
  local safe=0

  OPTIND=1

  while getopts 'hfFPsd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'reveal';;

      f) force=1;;

      F) force_continue=1;;

      P) preserve=1;;

      s) safe=1;;

      p) passphrase=$OPTARG;;

      d) homedir=$OPTARG;;

      *) _invalid_option_for 'reveal';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  # Command logic:

  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local counter=0
  local m_counter=0
  local to_show=( "$@" )

  if [ ${#to_show[@]} -eq 0 ]; then
    while read -r record; do
      to_show+=("$record")  # add record to array
    done < "$path_mappings"
  fi

  [[ ${safe} -eq 1 ]] && _check_if_plaintexts_have_conflicts "${to_show[@]}"

  for line in "${to_show[@]}"; do
    local filename
    local path
    filename=$(_get_record_filename "$line")
    path=$(_append_root_path "$filename")

    if [[ -f "$path" ]]; then
      # Plaintext file exists, we merge the content with the one in the secret file
      local merged_x
      local merged
      local has_conflicts
      if [[ -z "$passphrase" ]]; then
        merged_x=$(changes -g -- "$path"; echo x$?)
      else
        merged_x=$(changes -g -p "$passphrase" -- "$path"; echo x$?)
      fi
      merged="${merged_x%x*}";
      printf "%s" "${merged}" > "${path}"

      has_conflicts=$(_check_if_plaintext_has_conflicts "${path}")
      if [[ "1" == "${has_conflicts}" ]]; then
        m_counter=$((m_counter+1))
      fi
    else
      # Plaintext file does not exist, we decrypt the secret
      # The parameters are: filename, write-to-file, force, homedir, passphrase, error_ok
      _decrypt "$path" "1" "$force" "$homedir" "$passphrase" "$force_continue"
    fi

    if [[ ! -f "$path" ]]; then
      _warn_or_abort "cannot find decrypted version of file: $filename" "2" "$force_continue"
    else
      counter=$((counter+1))
      local secret_file
      secret_file=$(_get_encrypted_filename "$path")
      if [[ "$preserve" == 1 ]] && [[ -f "$secret_file" ]]; then
        local perms
        perms=$($SECRETS_OCTAL_PERMS_COMMAND "$secret_file")
        chmod "$perms" "$path"
      fi
    fi
  
  done

  echo "done. $counter of ${#to_show[@]} files are revealed (${m_counter} merged)."
}
