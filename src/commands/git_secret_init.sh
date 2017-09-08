#!/usr/bin/env bash

AWK_CHECK_GITIGNORE='
BEGIN { cnt=0; }
{
  if ( pattern == $0 )
    cnt++
}

END { print cnt }
'


function gitignore_has_pattern {
  local pattern
  local gitignore_file_path

  pattern="$1"
  gitignore_file_path=$(_append_root_path '.gitignore')

  _maybe_create_gitignore
  gawk -v pattern="$pattern" "$AWK_CHECK_GITIGNORE" "$gitignore_file_path"
}


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

  # verify random_seed file is ignored
  local random_seed_file
  local already_in
  random_seed_file=$(_append_root_path '.gitignore/random_seed')
  already_in=$(gitignore_has_pattern "$random_seed_file")
  [[ "$already_in" -gt 0 ]] && \
    echo "$random_seed_file" >> "$gitignore_file_path"
  # TODO: git attributes to view diffs
}
