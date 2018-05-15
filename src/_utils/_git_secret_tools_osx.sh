#!/usr/bin/env bash


# shellcheck disable=1117
function __replace_in_file_osx {
  sed -i.bak "s/^\($1[[:space:]]*=[[:space:]]*\).*\$/\1$2/" "$3"
}


function __temp_file_osx {
  : "${TMPDIR:=/tmp}"
  mktemp -t _gitsecrets_XXX
}


function __sha256_osx {
  /usr/bin/shasum -a256 "$1"
}
