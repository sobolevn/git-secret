#!/usr/bin/env bash


function _check_setup {
  # Checking git and secret-plugin setup:
  if [[ ! -d ".git" ]] || [[ ! -d ".git/hooks" ]]; then
    _abort "repository is broken. try running 'git init' or 'git clone'."
  fi

  # Checking if the '.gitsecret' is not ignored:
  local ignored=$(_check_ignore ".gitsecret/")
  if [[ ! $ignored -eq 1 ]]; then
    _abort ".gitsecret folder is ignored."
  fi

  # Checking gpg setup:
  local secring="$SECRETS_DIR_KEYS/secring.gpg"
  if [[ -f $secring ]] && [[ -s $secring ]]; then
    # secring.gpg is not empty, someone has imported a private key.
    _abort "it seems that someone has imported a secret key."
  fi
}


function _incorrect_usage {
  echo "$1"
  usage
  exit "$2"
}


function _init_script {
  # checking for proper set-up:
  _check_setup

  if [[ $# == 0 ]]; then
    _incorrect_usage "no input parameters provided." 126
  fi

  # load dependencies:
  # for f in ${0%/*}/src/*/*; do [[ -f "$f" ]] && . "$f"; done

  # routing the input command:
  if [[ $(_function_exists "$1") == 0 ]] && [[ ! $1 == _* ]]; then
    $1 "${@:2}"
  else
    _incorrect_usage "command $1 not found." 126
  fi
}

set -e
_init_script $@
