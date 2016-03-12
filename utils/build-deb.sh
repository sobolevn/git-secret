#!/usr/bin/env bash

set -e

# Initializing and settings:
READ_PEM=0744
EXEC_PEM=0755

SCRIPT_NAME="git-secret"
SCRIPT_DESCRIPTION="A bash-tool to store your private data inside a git repository."
SCRIPT_VERSION=$(bash ${PWD}/git-secret --version)
: ${SCRIPT_EPOCH:=0}
: ${SCRIPT_ITERATION:=1}

if [[ -z "$SCRIPT_BUILD_DIR" ]]; then
  SCRIPT_BUILD_DIR="${HOME}/debbuild-${SCRIPT_NAME}"
fi

SCRIPT_DEST_DIR="${SCRIPT_BUILD_DIR}/installroot"

# Preparing the files
rm -rf "$SCRIPT_BUILD_DIR"
mkdir -p "$SCRIPT_DEST_DIR"

# Coping the files inside the build folder:
install -b -m "$EXEC_PEM" "git-secret" "${SCRIPT_DEST_DIR}/git-secret"
install -m "$READ_PEM" -d "${SCRIPT_DEST_DIR}/man/man1"
for file in man/man1/* ; do
  if [[ "$file" == *.ronn ]]; then
    continue
  fi

  install -b -m "$READ_PEM" "$file" "${SCRIPT_DEST_DIR}/${file}"
done

# Building .deb package:
cd "$SCRIPT_DEST_DIR" && fpm -s dir -t deb \
  -a all \
  -n "$SCRIPT_NAME" \
  -d git \
  -d gpg \
  --epoch "$SCRIPT_EPOCH" \
  --version "$SCRIPT_VERSION" \
  --iteration "$SCRIPT_ITERATION" \
  --description="$SCRIPT_DESCRIPTION" \
  -C "$SCRIPT_DEST_DIR" \
  .
