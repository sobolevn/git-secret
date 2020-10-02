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

  echo "usage: git secret [--version] [command] [command-options]"
  echo ""
  echo "options:"
  echo " --version                 - prints the version number"
  echo ""
  echo "commands:"
  echo "see 'git secret [command] -h' for more info about commands and their options"
  echo " add [file.txt]            - adds file to be hidden to the list"
  echo " cat [file.txt]            - decrypts and prints contents of the file"
  echo " changes [file.txt.secret] - indicates if the file changed since last commit"
  echo " clean                     - deletes all encrypted files"
  echo " hide                      - encrypts (or re-encrypts) the files to be hidden"
  echo " init                      - initializes the  git-secret repository"
  echo " killperson [emails]       - deletes a person's public key from the keyring"
  echo " list                      - prints all the added files"
  echo " remove [files]            - removes files from the list of hidden files"
  echo " reveal                    - decrypts all hidden files"
  echo " tell [email]              - imports a person's public key into the keyring"
  echo " usage                     - prints this message"
  echo " whoknows                  - prints list of authorized email addresses"
}
