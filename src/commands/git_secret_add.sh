#!/usr/bin/env bash


function add {
  local auto_ignore=1
  OPTIND=1

  while getopts "ih" opt; do
    case "$opt" in
      i) auto_ignore=1;;    # this doesn't change anything

      h) _show_manual_for "add";;

      *) _invalid_option_for "add";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  _user_required

  # Checking if all files are correct (ignored and inside the repo):

  local not_ignored=()
  local items=( "$@" )

  # Checking if all files in options are ignored:
  for item in "${items[@]}"; do
    local path # absolute path
    local normalized_path # relative to the .git dir
    normalized_path=$(_git_normalize_filename "$item")
    path=$(_append_root_path "$normalized_path")

    # check that the file is not tracked
    local in_git
    in_git=$(_is_tracked_in_git "$item")
    if [[ "$in_git" -ne 0  ]]; then
       _abort "file tracked in git, consider using 'git rm --cached $item'"
    fi

    # Checking that file is valid:
    if [[ ! -f "$path" ]]; then
      _abort "file not found: $item"
    fi

    # Checking that it is ignored:
    local ignored
    ignored=$(_check_ignore "$path")

    if [[ "$ignored" -ne 0 ]]; then
      # Collect unignored files:
      not_ignored+=("$normalized_path")
    fi
  done

  # Are there any unignored files?

  if [[ ! "${#not_ignored[@]}" -eq 0 ]]; then
    # And show them all at once.
    local message
    message="these files are not in .gitignore: $*"

    if [[ "$auto_ignore" -eq 0 ]]; then
      # This file is not ignored. user don't want it to be added automatically.
      # Raise the exception, since all files, which will be hidden, must be ignored.
      # note that it is no longer possible to wind up in this code path as auto_ignore cannot be 0.
      # code left here in case we want to restore/modify this path later
      _abort "$message"
    else
      # In this case these files should be added to the `.gitignore` automatically:
      # see https://github.com/sobolevn/git-secret/issues/18 for more.
      _message "$message"
      _message "auto adding them to .gitignore"
      for item in "${not_ignored[@]}"; do
        _add_ignored_file "$item"
      done
    fi
  fi

  # Adding files to path mappings:

  local fsdb
  fsdb=$(_get_secrets_dir_paths_mapping)

  for item in "${items[@]}"; do
    local path
    local key
    path=$(_git_normalize_filename "$item")
    key="$path"

    # Adding files into system, skipping duplicates.
    local already_in
    already_in=$(_fsdb_has_record "$key" "$fsdb")
    if [[ "$already_in" -eq 1 ]]; then
      echo "$key" >> "$fsdb"
    fi
  done

  _message "${#@} item(s) added."
}
