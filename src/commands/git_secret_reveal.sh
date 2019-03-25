#!/usr/bin/env bash


function reveal {
  local homedir=''
  local passphrase=''
  local force=0             # this means 'clobber without warning'
  local force_continue=0    # this means 'continue if we have decryption errors'
  local preserve=0

  OPTIND=1

  while getopts 'hfFPd:p:v' opt; do
    # line below is for _SECRETS_VERBOSE
    # shellcheck disable=SC2034
    case "$opt" in
      h) _show_manual_for 'reveal';;

      f) force=1;;

      F) force_continue=1;;

      P) preserve=1;;

      p) passphrase=$OPTARG;;

      d) homedir=$(_clean_windows_path "$OPTARG");;

      v) _SECRETS_VERBOSE=1;;

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
  local to_show=( "$@" )

  if [ ${#to_show[@]} -eq 0 ]; then
    while read -r record; do
      to_show+=("$record")  # add record to array
    done < "$path_mappings"
  fi

  for line in "${to_show[@]}"; do
    local filename
    local path
    filename=$(_get_record_filename "$line")
    path=$(_append_root_path "$filename")

    # The parameters are: filename, write-to-file, force, homedir, passphrase, error_ok
    _decrypt "$path" "1" "$force" "$homedir" "$passphrase" "$force_continue"

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

  echo "git-secret: done. $counter of ${#to_show[@]} files are revealed."
}
