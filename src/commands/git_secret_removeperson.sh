#!/usr/bin/env bash


function removeperson {
  OPTIND=1

  while getopts 'h' opt; do
    case "$opt" in
      h) _show_manual_for 'removeperson';;

      *) _invalid_option_for 'removeperson';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  # Command logic:

  local emails=( "$@" )

  if [[ ${#emails[@]} -eq 0 ]]; then
    _abort "at least one email is required for removeperson."
  fi
  # Getting the local git-secret `gpg` key directory:
  local secrets_dir_keys
  secrets_dir_keys=$(_get_secrets_dir_keys)

  _assert_keyring_contains_emails_at_least_once "$secrets_dir_keys" "git-secret keyring" "${emails[@]}"

  local args=( --homedir "$secrets_dir_keys" --batch --yes )
  # we no longer use --no-permission-warning here in non-verbose mode, for #811

  for email in "${emails[@]}"; do
    # see https://github.com/bats-core/bats-core#file-descriptor-3-read-this-if-bats-hangs for info about 3>&-
    $SECRETS_GPG_COMMAND "${args[@]}" --delete-key "$email" 3>&-
    local exit_code=$?
    if [[ "$exit_code" -ne 0 ]]; then
      _abort "problem deleting key for '$email' with gpg: exit code $exit_code"
    fi
  done

  _message 'removed keys.'
  _message "now [$*] do not have an access to the repository."
  _message 'make sure to hide the existing secrets again.'
}

function killperson {
  echo "Warning: 'killperson' has been renamed to 'removeperson'. This alias will be removed in the future versions, please switch to call 'removeperson' going forward."

  removeperson "$@"
}
