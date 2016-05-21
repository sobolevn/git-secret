#!/usr/bin/env bash


function __replace_in_file_osx {
  sed -i.bak "s/^\($1[[:space:]]*=[[:space:]]*\).*\$/\1$2/" "$3"
}


function __temp_file_osx {
  : "${TMPDIR:=/tmp}"
  local filename=$(mktemp -t _gitsecrets_XXX )
  echo "$filename";
}
