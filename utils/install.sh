#!/usr/bin/env bash

set -e


# Credit goes to:
# https://github.com/sstephenson/bats/blob/master/install.sh
function resolve_link {
  $(type -p greadlink readlink | head -1) "$1"
}

function abs_dirname {
  local cwd
  local path="$1"

  cwd="$(pwd)"


  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

PREFIX="$1"
if [ -z "$PREFIX" ]; then
  echo "usage: $0 <prefix>" >&2
  exit 1
fi

SCRIPT_ROOT="$(dirname "$(abs_dirname "$0")")"

mkdir -p "$PREFIX"/bin "$PREFIX"/share/man/man1 "$PREFIX"/share/man/man7
cp "$SCRIPT_ROOT"/git-secret "$PREFIX"/bin/git-secret

# There was an issue with this line:
# cp -R "$SCRIPT_ROOT"/man/man1/* "$PREFIX"/share/man/man1
# see https://github.com/sobolevn/git-secret/issues/35 for reference.
find "$SCRIPT_ROOT"/man/man1 -name '*.1' -print0 | xargs -0 -I {} cp \
  -a {} "$PREFIX"/share/man/man1
cp "$SCRIPT_ROOT"/man/man7/git-secret.7 "$PREFIX"/share/man/man7/git-secret.7

echo "Installed git-secret to ${PREFIX}/bin/git-secret"
