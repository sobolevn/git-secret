#!/usr/bin/env bash


function usage {

  if [[ ! -z "$1" ]]; then
    echo $@
  fi

  local commands=""
  local separator="|"

  for com in $(compgen -A function)
  do
    if [[ ! $com == _* ]]; then
      commands+="$com$separator"
    fi
  done

  echo "usage: git secret [${commands%?}]"
  exit 0
}
