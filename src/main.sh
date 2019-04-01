#!/usr/bin/env bash

set -e

function _check_setup {
  # Checking git and secret-plugin setup:
  local is_tree
  is_tree=$(_is_inside_git_tree)
  if [[ "$is_tree" -ne 0 ]]; then
    _abort "not in dir with git repo. Use 'git init' or 'git clone', then in repo use 'git secret init'"
  fi

  # Checking if the '.gitsecret' dir (or as set by SECRETS_DIR) is not ignored:
  _secrets_dir_is_not_ignored

  # Checking gpg setup:
  local keys_dir
  keys_dir=$(_get_secrets_dir_keys)

  local secring="$keys_dir/secring.gpg"
  if [[ -f $secring ]] && [[ -s $secring ]]; then
    # secring.gpg exists and is not empty,
    # someone has imported a private key.
    _abort 'it seems that someone has imported a secret key.'
  fi
}


function _incorrect_usage {
  echo "git-secret: abort: $1"
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
    local function_exists
    function_exists=$(_function_exists "$1")

    if [[ "$function_exists" == 0 ]] && [[ ! $1 == _* ]]; then
      $1 "${@:2}"
    else  # TODO: elif [[ $(_plugin_exists $1) == 0 ]]; then
      _incorrect_usage "command $1 not found." 126
    fi
  fi
}

# gpg wrapper to pass passphrase to sops
# It is required to pass passphrase from git-secret command line
# as this feature is not supported by sops
function _gpg_sops_wrapper_decrypt {
  local args=()

  if [ -n "$SOPS_GPG_HOMEDIR" ]; then
    # required to tell gpg where keys are
    args+=( "--homedir" "$SOPS_GPG_HOMEDIR" )
  fi

  if [[ "$GPG_VER_21" -eq 1 ]]; then
    # required to pass passphrase through fd
    args+=( "--pinentry-mode" "loopback" )
  fi

  if [ -n "$SOPS_GPG_PASSPHRASE" ]; then
    # sops passes data to encrypt on stdin so we need
    # a new file descriptor to pass passphrase
    exec 3<<<"$SOPS_GPG_PASSPHRASE"
    ${SECRETS_GPG_COMMAND} -d "${args[@]}" --batch --passphrase-fd 3
    exec 3<&-
  else
    ${SECRETS_GPG_COMMAND} "${args[@]}" "$@"
  fi
}

# git-secret can be used as git-secret or as a gpg command wrapper (sops mode)
# XXX trying to guess whether gpg command wrapper is used based on gpg set by sops
# See https://github.com/mozilla/sops/blob/master/pgp/keysource.go
if echo "$@" | grep -e '--use-agent' > /dev/null ; then 
  _gpg_sops_wrapper_decrypt "$@"
else
  _init_script "$@"
fi
