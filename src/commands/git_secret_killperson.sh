#!/usr/bin/env bash


function killperson {
  _user_required

  if [[ ${#@} -eq 0 ]]; then
    _abort "email is required."
  fi

  $GPGLOCAL --batch --yes --delete-key "$1"
}
