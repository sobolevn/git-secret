#!/usr/bin/env bash


function _show_help_clean {
  echo "usage: git secret clean"
  echo "removes all the hidden files."
  echo
  echo "  -v        shows which files are deleted."
  exit 0
}


function clean {
  OPTIND=1

  local verbose=""
  while getopts "vh" opt; do
    case "$opt" in
      v)
        verbose="v"
      ;;

      h)
        _show_help_clean
      ;;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  [[ ! -z $verbose ]] && echo && echo "cleaing:" || :  # bug with custom bash on OSX

  find . -name *$SECRETS_EXTENSION -type f | xargs rm -f$verbose

  [[ ! -z $verbose ]] && echo || :  # bug with custom bash on OSX

}
