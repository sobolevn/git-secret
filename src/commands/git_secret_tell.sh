#!/usr/bin/env bash


function tell {
  local emails
  local self_email=0
  local homedir

  # A POSIX variable
  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  while getopts "hmd:" opt; do
    case "$opt" in
      h) _show_manual_for "tell";;

      m) self_email=1;;

      d) homedir=$OPTARG;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # Validates that application is inited:
  _secrets_dir_exists

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

  for email in "${emails[@]}"; do
    # This file will be removed automatically:
    _temporary_file  # note, that `_temporary_file` will export `filename` var.
    # shellcheck disable=2154
    local keyfile="$filename"

    if [[ -z "$homedir" ]]; then
      $SECRETS_GPG_COMMAND --export -a "$email" > "$keyfile"
    else
      # It means that homedir is set as an extra argument via `-d`:
      $SECRETS_GPG_COMMAND --no-permission-warning --homedir="$homedir" \
        --export -a "$email" > "$keyfile"
    fi

    if [[ ! -s "$keyfile" ]]; then
      _abort 'gpg key is empty. check your key name: "gpg --list-keys".'
    fi

    # Importing public key to the local keychain:
    $GPGLOCAL --import "$keyfile" > /dev/null 2>&1
  done

  echo "done. ${emails[*]} added as someone who know(s) the secret."
}
