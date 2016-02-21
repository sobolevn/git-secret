#!/usr/bin/env bash

<<<<<<< HEAD

function _show_help_tell {
  cat <<-EOF
usage: git secret tell [-m] [-d dir] [email]
adds a person, who can access the private data.

options:
  -m        - takes your current 'git config user.email' as an identifier for the key.
  -d        - specifies '--homedir' option for the 'gpg'
  -h        shows this help.

EOF
  exit 0
}


=======
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
function tell {
  _secrets_dir_exists

  # A POSIX variable
  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  local email
  local homedir

  while getopts "h?md:" opt; do
    case "$opt" in
<<<<<<< HEAD
      h) _show_help_tell;;

      m) # Set email of the git current user:
        email=$(git config user.email) || _abort "'git congig user.email' is not set."
      ;;

      d) homedir=$OPTARG;;
=======
      h|\?)
        usage
      ;;

      m) # Set email of the git current user:
        email=$(git config user.email) || email=""

        if [[ -z $email ]]; then
          _abort "empty email for current git user."
        fi
      ;;

      d)
        homedir=$OPTARG
      ;;
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # Custom argument-parsing:
  if [[ -z $email ]]; then
    # Email was not set via `-m` and is in $1:
<<<<<<< HEAD
    test ! -z "$1" && email="$1"; shift || _abort "first argument must be an email address."
=======
    email="$1"
    if [[ -z $email ]]; then
      _abort "first argument must be an email address."
    fi
    shift
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
  fi

  # This file will be removed automatically:
  _temporary_file
<<<<<<< HEAD
  local keyfile="$filename"

  if [[ -z "$homedir" ]]; then
=======
  local keyfile=$filename

  if [[ -z $homedir ]]; then
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    $SECRETS_GPG_COMMAND --export -a "$email" > "$keyfile"
  else
    # It means that homedir is set as an extra argument via `-d`:
    $SECRETS_GPG_COMMAND --no-permission-warning --homedir="$homedir" --export -a "$email" > "$keyfile"
  fi

<<<<<<< HEAD
  if [[ ! -s "$keyfile" ]]; then
=======
  if [[ ! -s $keyfile ]]; then
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    _abort 'gpg key is empty. check your key name: `gpg --list-keys`.'
  fi

  # Importing public key to the local keychain:
  $GPGLOCAL --import "$keyfile" > /dev/null 2>&1

  echo "done. $email added as a person who knows the secret."
}
