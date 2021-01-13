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

  _assert_keyring_contains_emails "$secrets_dir_keys" "git-secret keyring" "${emails[@]}"

  for email in "${emails[@]}"; do
    # see https://github.com/bats-core/bats-core#file-descriptor-3-read-this-if-bats-hangs for info about 3>&-
    $SECRETS_GPG_COMMAND --homedir "$secrets_dir_keys" --no-permission-warning --batch --yes --delete-key "$email" 3>&-
    local exit_code=$?
    if [[ "$exit_code" -ne 0 ]]; then
      _abort "problem deleting key for '$email' with gpg: exit code $exit_code"
    fi
  done

  _message 'removed keys.'
  _message "now [$*] do not have an access to the repository."
  _message 'make sure to hide the existing secrets again.'
}
