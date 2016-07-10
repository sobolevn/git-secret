#!/usr/bin/env bash

set -e


PREFIX="$1"
if [ -z "$PREFIX" ]; then
  echo "usage: $0 <prefix>" >&2
  exit 1
fi

# Binary:
rm -f "$PREFIX"/bin/git-secret

# Manuals:
find "$PREFIX"/share/man/man1 -type f -name "git-secret-*.1" -exec rm -f {} \;
rm -f "$PREFIX"/share/man/man7/git-secret.7
