#!/usr/bin/env bash

set -e


# Credit goes to:
# https://github.com/bats-core/bats-core/blob/master/install.sh (with alterations)
resolve_link() {
  $(type -p greadlink readlink | head -n1) "$1"
}

abs_dirname() {
  local cwd
  cwd="$(pwd)"
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
  { echo "usage: $0 <prefix>"
    echo "  e.g. $0 /usr/local"
  } >&2
  exit 1
fi

BATS_ROOT="$(abs_dirname "$0")"
mkdir -p "$PREFIX"/{bin,libexec,share/man/man{1,7}}
cp -R "$BATS_ROOT"/bin/* "$PREFIX"/bin
cp -R "$BATS_ROOT"/libexec/* "$PREFIX"/libexec
# There was an issue with this line:
# cp -R "$SCRIPT_ROOT"/man/man1/* "$PREFIX"/share/man/man1
# see https://github.com/sobolevn/git-secret/issues/35 for reference.
find "$SCRIPT_ROOT"/man/man1 -name '*.1' -print0 | xargs -0 -I {} cp \
  -a {} "$PREFIX"/share/man/man1
cp "$SCRIPT_ROOT"/man/man7/git-secret.7 "$PREFIX"/share/man/man7/git-secret.7

# fix broken symbolic link file
if [ ! -L "$PREFIX"/bin/bats ]; then
	local dir
    dir="$(readlink -e "$PREFIX")"
    rm -f "$dir"/bin/bats
    ln -s "$dir"/libexec/bats "$dir"/bin/bats
fi

# fix file permission
chmod a+x "$PREFIX"/bin/*
chmod a+x "$PREFIX"/libexec/*

echo "Installed git-secret to ${PREFIX}/bin/git-secret"
