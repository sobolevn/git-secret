#!/usr/bin/env bash


# shellcheck disable=1117
function __replace_in_file_osx {
  sed -i.bak "s/^\($1[[:space:]]*=[[:space:]]*\).*\$/\1$2/" "$3"
}


function __temp_file_osx {
  : "${TMPDIR:=/tmp}"
  local filename
  filename=$(mktemp -t _gitsecrets_XXX )
  echo "$filename";
}


function __sha256_osx {
  /usr/bin/shasum -a256 "$1"
}
function __get_octal_perms_osx {
  local filename
  filename=$1
  local perms
  perms=$(stat -f '%p' "$filename")
  # a string like '100644'
  echo "$perms"
}
