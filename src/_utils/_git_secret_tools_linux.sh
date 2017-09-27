#!/usr/bin/env bash


# shellcheck disable=1117
function __replace_in_file_linux {
  sed -i.bak "s/^\($1\s*=\s*\).*\$/\1$2/" "$3"
}


function __temp_file_linux {
  local filename
  filename=$(mktemp)
  echo "$filename"
}
