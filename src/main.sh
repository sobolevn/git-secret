#!/usr/bin/env bash

set -e

function _check_setup {
  # Checking git and secret-plugin setup:
  if [[ ! -d ".git" ]] || [[ ! -d ".git/hooks" ]]; then
    _abort "repository is broken. try running 'git init' or 'git clone'."
  fi

  # Checking if the '.gitsecret' is not ignored:
  local ignored
  ignored=$(_check_ignore ".gitsecret/")
  if [[ ! $ignored -eq 1 ]]; then
    _abort '.gitsecret folder is ignored.'
  fi

  # Checking gpg setup:
  local secring="$SECRETS_DIR_KEYS/secring.gpg"
  if [[ -f $secring ]] && [[ -s $secring ]]; then
    # secring.gpg is not empty, someone has imported a private key.
    _abort 'it seems that someone has imported a secret key.'
  fi
}


function _incorrect_usage {
  echo "$1"
  usage
  exit "$2"
}


function _show_version {
  echo "$GITSECRET_VERSION"
  exit 0
}


function _init_script {
  if [[ $# == 0 ]]; then
    _incorrect_usage 'no input parameters provided.' 126
  fi

  # Parse plugin-level options:
  local dry_run=0

  while [[ $# -gt 0 ]]; do
    local opt="$1"

    case "$opt" in
      # Options for quick-exit strategy:
      --dry-run)
        dry_run=1
        shift;;

      --version) _show_version;;

      *) break;;  # do nothing
    esac
  done

  if [[ "$dry_run" == 0 ]]; then
    # Checking for proper set-up:
    _check_setup

    # Routing the input command:
    if [[ $(_function_exists "$1") == 0 ]] && [[ ! $1 == _* ]]; then
      $1 "${@:2}"
    else  # TODO: elif [[ $(_plugin_exists $1) == 0 ]]; then
      _incorrect_usage "command $1 not found." 126
    fi
  fi
}


_init_script "$@"
