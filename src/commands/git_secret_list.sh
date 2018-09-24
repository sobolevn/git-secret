#!/usr/bin/env bash


function list {
  OPTIND=1

  while getopts 'h' opt; do
    case "$opt" in
      h) _show_manual_for 'list';;

      *) _invalid_option_for 'list';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  # Command logic:
  filenames=()
  _list_all_added_files  # exports 'filenames' array
  local filename
  for filename in "${filenames[@]}"; do
    echo "$filename"
  done
}
