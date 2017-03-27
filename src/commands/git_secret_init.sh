#!/usr/bin/env bash


function init {
  OPTIND=1

  while getopts 'h' opt; do
    case "$opt" in
      h) _show_manual_for 'init';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  # Check if '.gitsecret/' already exists:
  local git_secret_dir
  git_secret_dir=$(_get_secrets_dir)

  if [[ -d "$git_secret_dir" ]]; then
    _abort 'already inited.'
  fi

  # Check if it is ignored:
  _secrets_dir_is_not_ignored

  # Create internal files:

  mkdir "$git_secret_dir" "$(_get_secrets_dir_keys)" "$(_get_secrets_dir_path)"
  touch "$(_get_secrets_dir_keys_mapping)" "$(_get_secrets_dir_paths_mapping)"

  echo "'$git_secret_dir/' created."
}
