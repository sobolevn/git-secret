#!/usr/bin/env bash

# support for freebsd. Mostly the same as OSX.


# shellcheck disable=1117
function __replace_in_file_freebsd {
  sed -i.bak "s/^\($1[[:space:]]*=[[:space:]]*\).*\$/\1$2/" "$3"
}


function __temp_file_freebsd {
  : "${TMPDIR:=/tmp}"
  local filename
  filename=$(mktemp -t _gitsecrets_XXX )
  echo "$filename";
}


function __sha256_freebsd {
  # this is in a different location than osx
  /usr/local/bin/shasum -a256 "$1"
}
function __get_octal_perms_freebsd {
  local filename
  filename=$1
  local perms
  perms=$(stat -f '%p' "$filename" | cut -b3-6)
  # stat -f '%p' FILENAME on freebsd gives string like 100644. chmod on freebsd expects 0644.
  # so we use 'cut' to strip of last four bytes of string.
  echo "$perms"
}
