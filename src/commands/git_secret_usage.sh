#!/usr/bin/env bash


function usage {
  OPTIND=1

  while getopts "h?" opt; do
    case "$opt" in
      h) _show_manual_for "usage";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  local commands="add|changes|clean|hide|init|killperson|list|remove|reveal|tell|usage|whoknows"

  echo "usage: git secret [${commands}]"
}
