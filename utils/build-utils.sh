#!/usr/bin/env bash

set -e

# Initializing and settings:
READ_PEM=0644
EXEC_PEM=0755

SCRIPT_NAME="git-secret"
SCRIPT_DESCRIPTION="A bash-tool to store your private data inside a git repository."
SCRIPT_VERSION=$(bash "${PWD}"/git-secret --version)

# This might be overridden someday:
: "${SCRIPT_EPOCH:=0}"
: "${SCRIPT_ITERATION:=1}"

# This may be overridden:
if [[ -z "$SCRIPT_BUILD_DIR" ]]; then
  SCRIPT_BUILD_DIR="${PWD}/build"
fi

SCRIPT_DEST_DIR="${SCRIPT_BUILD_DIR}/buildroot"


function locate_deb {
  find . -maxdepth 1 -name "$SCRIPT_DEST_DIR/*.deb" | head -1
}


function locate_rpm {
  find . -maxdepth 1 -name "$SCRIPT_DEST_DIR/*.rpm" | head -1
}


function preinstall_files {
  # Preparing the files:
  rm -rf "$SCRIPT_BUILD_DIR"
  mkdir -p "$SCRIPT_DEST_DIR"

  # Coping the files inside the build folder:
  install -D -T -b -m "$EXEC_PEM" -T "git-secret" "${SCRIPT_DEST_DIR}/usr/bin/git-secret"
  install -m "$EXEC_PEM" -d "${SCRIPT_DEST_DIR}/usr/share/man/man1"
  install -m "$EXEC_PEM" -d "${SCRIPT_DEST_DIR}/usr/share/man/man7"
  for file in man/man1/* ; do
    if [[ "$file" == *.ronn ]]; then
      continue
    fi

    install -D -T -b -m "$READ_PEM" -T "$file" "${SCRIPT_DEST_DIR}/usr/share/$file"
  done
  install -D -T -b -m "$READ_PEM" -T "man/man7/git-secret.7" \
    "${SCRIPT_DEST_DIR}/usr/share/man/man7/git-secret.7"
}


function build_package {
  # Only requires `rpm` or `deb` as first argument:
  local build_type="$1"

  # See https://github.com/jordansissel/fpm for docs:
  fpm \
    -s dir \
    -t "$build_type" \
    -a all \
    -n "$SCRIPT_NAME" \
    --version "$SCRIPT_VERSION" \
    --description "$SCRIPT_DESCRIPTION" \
    --url "https://sobolevn.github.io/git-secret/" \
    --maintainer "Nikita Sobolev (mail@sobolevn.me)" \
    --license "MIT" \
    -C "$SCRIPT_DEST_DIR" \
    -d "git" \
    -d "gnupg" \
    --deb-no-default-config-files \
    .
}


function clean_up_files {
  rm -rf "${SCRIPT_DEST_DIR:?}/usr"
}
