#!/usr/bin/env bash


# shellcheck disable=1117
function __replace_in_file_osx {
  sed -i.bak "s/^\($1[[:space:]]*=[[:space:]]*\).*\$/\1$2/" "$3"
}


function __temp_file_osx {
  : "${TMPDIR:=/tmp}"
  local filename
  # man mktemp on OSX: 
  # ...
  # "If the -t prefix option is given, mktemp will generate a template string
  #   based on the prefix and the _CS_DARWIN_USER_TEMP_DIR configuration vari-
  #   able if available.  Fallback locations if _CS_DARWIN_USER_TEMP_DIR is not
  #   available are TMPDIR and /tmp."

  # we use /usr/bin/mktemp in case there's another mktemp available. See #485
  filename=$(/usr/bin/mktemp -t _git_secret )    
  # On OSX this can make a filename like 
  # '/var/folders/nz/vv4_91234569k3tkvyszvwg90009gn/T/_git_secret.HhvUPlUI'
  echo "$filename";
}


function __sha256_osx {
  /usr/bin/shasum -a256 "$1"
}

function __get_octal_perms_osx {
  local filename
  filename=$1
  local perms
  perms=$(stat -f "%04OLp" "$filename")
  # see _git_secret_tools_freebsd.sh for more about stat's format string
  echo "$perms"
}

function __epoch_to_date_osx {
  local epoch=$1;
  if [ -z "$epoch" ]; then
    echo ''
  else
    #date -r 234234234 +"%Y-%m-%d"
    local datetime
    datetime=$(date -r "$epoch" +'%Y-%m-%d')
    echo "$datetime"
  fi
}

