#!/usr/bin/env bash


function killperson {
  OPTIND=1

  while getopts 'h' opt; do
    case "$opt" in
      h) _show_manual_for 'killperson';;

      *) _invalid_option_for 'killperson';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  # Command logic:

  local emails=( "$@" )

  if [[ ${#emails[@]} -eq 0 ]]; then
    _abort "at least one email is required for killperson."
  fi
  # Getting the local git-secret `gpg` key directory:
  local secrets_dir_keys
  secrets_dir_keys=$(_get_secrets_dir_keys)

  # TODO: this block is duplicated in git_secret_tell.sh and should be factored
  local gpg_uids
  gpg_uids=$(_get_users_in_gpg_keyring "$secrets_dir_keys")
  for email in "${emails[@]}"; do
    local email_ok=0
    for uid in $gpg_uids; do
        if [[ "$uid" == "$email" ]]; then
            email_ok=1
        fi
    done
    if [[ "$email_ok" == 0 ]]; then
      _abort "email not found in gpg keyring: $email"
    fi
  done

  for email in "${emails[@]}"; do
    $SECRETS_GPG_COMMAND --homedir "$secrets_dir_keys" --no-permission-warning --batch --yes --delete-key "$email"
    local exit_code=$?
    if [[ "$exit_code" -ne 0 ]]; then
      _abort "problem deleting key for '$email' with gpg: exit code $exit_code"
    fi
  done

  echo 'removed keys.'
  echo "now [$*] do not have an access to the repository."
  echo 'make sure to hide the existing secrets again.'
}
