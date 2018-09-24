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

function __sha256_linux {
  sha256sum "$1"
}

function __get_octal_perms_linux {
  local filename
  filename=$1
  local perms
  perms=$(stat --format '%a' "$filename")
  # a string like '0644'
  echo "$perms"
}
