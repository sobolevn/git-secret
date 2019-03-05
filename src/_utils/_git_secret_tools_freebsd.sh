#!/usr/bin/env bash

# support for freebsd. Mostly the same as MacOS.


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
  # this is in a different location than MacOS
  /usr/local/bin/shasum -a256 "$1"
}

function __get_octal_perms_freebsd {
  local filename
  filename=$1
  local perms
  perms=$(stat -f "%04OLp" "$filename")
  # perms is a string like '0644'. 
  # In the "%04OLp':
  #   the '04' means 4 digits, 0 padded.  So we get 0644, not 644.
  #   the 'O' means Octal.
  #   the 'Lp' means 'low subfield of file type and permissions (st_mode).'
  #     (without 'L' you get 6 digits like '100644'.)
  echo "$perms"
}

function __epoch_to_date_freebsd {
  local epoch=$1;
  if [ -z "$epoch" ]; then
    echo ''
  else
    local cmd="date +%F -r $epoch"
    local datetime
    datetime=$($cmd)
    echo "$datetime"
  fi
}
