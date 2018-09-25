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

  _assert_keychain_contains_emails "$secrets_dir_keys" "${emails[@]}"

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
