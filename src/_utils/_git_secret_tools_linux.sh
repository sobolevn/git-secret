#!/usr/bin/env bash


# shellcheck disable=1117
function __replace_in_file_linux {
  sed -i.bak "s/^\($1\s*=\s*\).*\$/\1$2/" "$3"
}


function __temp_file_linux {
  : "${TMPDIR:=/tmp}"
  local filename
  # man mktemp on CentOS 7:
  # mktemp [OPTION]... [TEMPLATE]
  # ... 
  #  -p DIR, --tmpdir[=DIR]
  #        interpret TEMPLATE relative to DIR; if DIR is not specified, 
  #        use $TMPDIR if set, else /tmp.  With this option, TEMPLATE 
  #        must not be an absolute name; unlike  with -t, TEMPLATE may 
  #        contain slashes, but mktemp creates only the final component
  # ...
  #  -t     interpret TEMPLATE as a single file name component, 
  #         relative to a directory: $TMPDIR, if set; else the directory 
  #         specified via -p; else /tmp [deprecated]

  filename=$(mktemp -p "${TMPDIR}" _git_secret.XXXXXX ) 
  # makes a filename like /$TMPDIR/_git_secret.ONIHoR
  echo "$filename"
}

function __sha256_linux {
  sha256sum "$1"
}

function __get_octal_perms_linux {
  local filename
  filename=$1

  # we assume stat is from busybox if it's a symlink
  local stat_from_busybox=0
  local stat_path
  stat_path=$(command -v stat)
  if [ -L "$stat_path" ]; then
    stat_from_busybox=1
  fi

  local perms   # a string like '0644'
  if [ $stat_from_busybox -eq 1 ]; then
    # special case for busybox, which doesn't understand --format
    perms=$(stat -f '%a' "$filename")
  else
    perms=$(stat --format '%a' "$filename")
  fi
  echo "$perms"
}

function __epoch_to_date_linux {
  local epoch=$1;
  if [ -z "$epoch" ]; then
    echo ''
  else
    local cmd="date +%F -d @$epoch"
    local datetime
    datetime=$($cmd)
    echo "$datetime"
  fi
}
