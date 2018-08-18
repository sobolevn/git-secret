#!/usr/bin/env bash


function reveal {
  local homedir=''
  local passphrase=''
  local force=0
  local preserve=0

  OPTIND=1

  while getopts 'hfPd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'reveal';;

      f) force=1;;

      P) preserve=1;;

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
  while read -r line; do
    local filename
    local path
    filename=$(_get_record_filename "$line")
    path=$(_append_root_path "$filename")

    # The parameters are: filename, write-to-file, force, homedir, passphrase
    _decrypt "$path" "1" "$force" "$homedir" "$passphrase"

    if [[ ! -f "$path" ]]; then
      _abort "cannot find decrypted version of file: $filename"
    fi

    if [[ "$preserve" == 1 ]]; then
      local secret_file
      secret_file=$(_get_encrypted_filename "$path")
      local perms
      perms=$($SECRETS_OCTAL_PERMS_COMMAND "$secret_file")
      chmod "$perms" "$path"
    fi

    counter=$((counter+1))
  done < "$path_mappings"

  echo "done. all $counter files are revealed."
}
