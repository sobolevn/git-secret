#!/usr/bin/env bash


function usage {
<<<<<<< HEAD
  local commands=""
  local separator="|"

  for com in $(compgen -A function); do
=======

  if [[ ! -z "$1" ]]; then
    echo $@
  fi

  local commands=""
  local separator="|"

  for com in $(compgen -A function)
  do
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
    if [[ ! $com == _* ]]; then
      commands+="$com$separator"
    fi
  done

  echo "usage: git secret [${commands%?}]"
<<<<<<< HEAD
=======
  exit 0
>>>>>>> 9d38280603b2b61d2ec991a031c0e776adde6f18
}
