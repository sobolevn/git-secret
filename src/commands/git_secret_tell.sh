#!/usr/bin/env bash

function tell {
  _secrets_dir_exists

  # A POSIX variable
  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  local email
  local homedir

  while getopts "h?md:" opt; do
    case "$opt" in
      h|\?)
        usage
      ;;

      m) # Set email of the git current user:
        email=$(git config user.email) || email=""

        if [[ -z $email ]]; then
          _abort "empty email for current git user."
        else
          echo "$email is not empty"
        fi
      ;;

      d)
        homedir=$OPTARG
      ;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # Custom argument-parsing:
  if [[ -z $email ]]; then
    # Email was not set via `-m` and is in $1:
    email="$1"
    if [[ -z $email ]]; then
      _abort "first argument must be an email address."
    fi
    shift
  fi

  # This file will be removed automatically:
  _temporary_file
  local keyfile=$filename

  if [[ -z $homedir ]]; then
    $SECRETS_GPG_COMMAND --export -a "$email" > "$keyfile"
  else
    # It means that homedir is set as an extra argument via `-d`:
    $SECRETS_GPG_COMMAND --no-permission-warning --homedir="$homedir" --export -a "$email" > "$keyfile"
  fi

  if [[ ! -s $keyfile ]]; then
    _abort 'gpg key is empty. check your key name: `gpg --list-keys`.'
  fi

  # Importing public key to the local keychain:
  $GPGLOCAL --import "$keyfile" > /dev/null 2>&1

  echo
  echo "done. $email added as a person who knows the secret."
}
