#!/usr/bin/env bash
set -e

# Credit goes to:
# https://github.com/sstephenson/bats/blob/master/install.sh
resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

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

SCRIPT_ROOT="$(dirname $(abs_dirname "$0"))"

mkdir -p "$PREFIX"/bin "$PREFIX"/share/man/man1 "$PREFIX"/share/man/man7
cp "$SCRIPT_ROOT"/git-secret "$PREFIX"/bin/git-secret
cp -R "$SCRIPT_ROOT"/man/man1/* "$PREFIX"/share/man/man1
cp "$SCRIPT_ROOT"/man/man7/git-secret.7 "$PREFIX"/share/man/man7/git-secret.7

echo "Installed git-secret to $PREFIX/bin/git-secret"
