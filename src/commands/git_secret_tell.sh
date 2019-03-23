#!/usr/bin/env bash

# shellcheck disable=2016
AWK_GPG_KEY_CNT='
BEGIN { cnt=0; OFS=":"; FS=":"; }
flag=0; $1 == "pub" { cnt++ }
END { print cnt }
'

function get_gpg_key_count {
  local secrets_dir_keys
  secrets_dir_keys=$(_get_secrets_dir_keys)
  $SECRETS_GPG_COMMAND --homedir "$secrets_dir_keys" --no-permission-warning --list-public-keys --with-colon | gawk "$AWK_GPG_KEY_CNT"
  local exit_code=$?
  if [[ "$exit_code" -ne 0 ]]; then
    _abort "problem counting keys with gpg: exit code $exit_code"
  fi
}

function tell {
  local emails
  local self_email=0
  local homedir

  # A POSIX variable
  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  while getopts "vhmd:" opt; do
    case "$opt" in
      v) _SECRETS_VERBOSE=1;;

      h) _show_manual_for "tell";;

      m) self_email=1;;

      d) homedir=$(_clean_windows_path "$OPTARG");;

      *) _invalid_option_for 'tell';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # Validates that application is initialized:
  _secrets_dir_exists

  # Command logic:
  emails=( "$@" )
  local git_email

  if [[ "$self_email" -eq 1 ]]; then
    git_email=$(git config user.email)

    if [[ -z "$git_email" ]]; then
      _abort "'git config user.email' is not set."
    fi

    emails+=("$git_email")
  fi

  if [[ "${#emails[@]}" -eq 0 ]]; then
    # If after possible addition of git_email, emails are still empty,
    # we should raise an exception.
    _abort "you must provide at least one email address."
  fi

  _assert_keychain_contains_emails "$homedir" "${emails[@]}"

  local start_key_cnt
  start_key_cnt=$(get_gpg_key_count)
  for email in "${emails[@]}"; do
    # This file will be removed automatically:
    _temporary_file  # note that `_temporary_file` will export `temporary_filename` var.
    # shellcheck disable=2154
    local keyfile="$temporary_filename"

    local exit_code
    if [[ -z "$homedir" ]]; then
      $SECRETS_GPG_COMMAND --export -a "$email" > "$keyfile"
      exit_code=$?
    else
      # It means that homedir is set as an extra argument via `-d`:
      $SECRETS_GPG_COMMAND --no-permission-warning --homedir="$homedir" \
        --export -a "$email" > "$keyfile"
      exit_code=$?
    fi
    if [[ "$exit_code" -ne 0 ]]; then
      _abort "problem exporting public key for '$email' with gpg: exit code $exit_code"
    fi

    if [[ ! -s "$keyfile" ]]; then
      _abort "no keyfile found for '$email'. Check your key name: 'gpg --list-keys'."
    fi

    # Importing public key to the local keychain:
    local secrets_dir_keys
    secrets_dir_keys=$(_get_secrets_dir_keys)

    local args=( --homedir "$secrets_dir_keys" --no-permission-warning --import "$keyfile" )
    if [[ -z "$_SECRETS_VERBOSE" ]]; then
      $SECRETS_GPG_COMMAND "${args[@]}" > /dev/null 2>&1
    else
      $SECRETS_GPG_COMMAND "${args[@]}"
    fi
    exit_code=$?
    if [[ "$exit_code" -ne 0 ]]; then
      _abort "problem importing public key for '$email' with gpg: exit code $exit_code"
    fi
  done

  echo "done. ${emails[*]} added as someone who know(s) the secret."

  # force re-encrypting of files if required
  local fsdb
  local end_key_cnt
  fsdb=$(_get_secrets_dir_paths_mapping)
  end_key_cnt=$(get_gpg_key_count)
  [[ $start_key_cnt -ne $end_key_cnt ]] && _fsdb_clear_hashes "$fsdb"
}
