#!/bin/bash

function init {
  # A POSIX variable
  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  output_file=""
  verbose=0

  while getopts "h?vf:" opt; do
    case "$opt" in
    h|\?)
      usage
      ;;
    v)
      verbose=1
      ;;
    f)
      output_file=$OPTARG
      ;;
    esac

    shift $((OPTIND-1))

    [ "$1" = "--" ] && shift
  done

  echo "verbose=$verbose, output_file='$output_file', Leftovers: $@"

}
