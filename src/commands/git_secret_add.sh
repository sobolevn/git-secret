#!/usr/bin/env bash


function add {
  OPTIND=1

  while getopts "ihv" opt; do
    case "$opt" in
      i) ;;    # this doesn't change anything

      h) _show_manual_for "add";;

      v) _SECRETS_VERBOSE=1;;

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
    path=$(_prepend_root_path "$normalized_path")

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
    # Add these files to `.gitignore` automatically:
    # see https://github.com/sobolevn/git-secret/issues/18 for more.

    # NOTE: output has spaces between filenames, which can be ambiguous if files also have spaces
    _message "files not in .gitignore, adding: ${not_ignored[*]}"
    for item in "${not_ignored[@]}"; do
      _add_ignored_file "$item"
    done
  fi

  # Adding files to path mappings:

  local fsdb
  fsdb=$(_get_secrets_dir_paths_mapping)
  local count
  count=0

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
       if [[ -n "$_SECRETS_VERBOSE" ]]; then
        _message "adding file: $key"
      fi

      ((count=count+1))
    fi
  done

  _message "$count item(s) added."
}
