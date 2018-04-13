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

  echo "usage: git secret [$commands]"
}
