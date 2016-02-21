#!/usr/bin/env bash


function usage {
  local commands=""
  local separator="|"

  for com in $(compgen -A function); do
    if [[ ! $com == _* ]]; then
      commands+="$com$separator"
    fi
  done

  echo "usage: git secret [${commands%?}]"
}
