#!/usr/bin/env bash


function usage {
  OPTIND=1

  while getopts "h?" opt; do
    case "$opt" in
      h) _show_manual_for "usage";;

      *) _invalid_option_for "usage";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # There was a bug with some shells, which were adding extra commands
  # to the old dynamic-loading version of this code.
  # thanks to @antmak it is now fixed, see:
  # https://github.com/sobolevn/git-secret/issues/47
  local commands="add|cat|changes|clean|hide|init|killperson|list|remove|reveal|tell|usage|whoknows"

  echo "usage: git secret [--version] [$commands]"
  echo " 'git secret --version' will show version and exit"
  echo "See 'git secret [command] -h' for more info about commands and their options"
  echo " add [filename.txt] - adds file to be hidden, optionally adds file to .gitignore"
  echo " cat [filename.txt] - cats the decrypted contents of the named file to stdout"
  echo " changes [filename.secret] - indicates if the file has changed since checkin"
  echo " clean - deletes encrypted files"
  echo " hide - encrypts (or re-encrypts) the files to be hidden"
  echo " init - creates the .gitsecret directory and contents needed for git-secret"
  echo " killperson [emails] - the reverse of 'tell', removes access for the named user"
  echo " list - shows files to be hidden/encrypted, as in .gitsecret/paths/mapping.cfg"
  echo " remove [files] - removes files from list of hidden files"
  echo " reveal - decrypts all hidden files, as mentioned in 'git secret list'"
  echo " tell [email] - add access for the user with imported public key with email"
  echo " whoknows - shows list of email addresses associated with public keys that can reveal files"
}
